using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using Swashbuckle.AspNetCore.Annotations;
using System.Security.Claims;
using VPBE.API.Controllers.Base;
using VPBE.Domain.Attributes;
using VPBE.Domain.Dtos;
using VPBE.Domain.Dtos.Reports;
using VPBE.Domain.Entities;
using VPBE.Domain.Models.Reports;
using VPBE.Domain.Interfaces;
using VPBE.Domain.Extensions;
using VPBE.Domain.Audit;

namespace VPBE.API.Controllers
{
    public class ReportController : ApiBaseController
    {
        private readonly IDBRepository _dBRepository;

        public ReportController(IDBRepository dBRepository)
        {
            this._dBRepository = dBRepository;
        }
        [HttpPost("filter")]
        [Permission(new UserRole[] { UserRole.Admin, UserRole.Member })]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<List<FilterResult>>))]
        public async Task<IActionResult> GetReport([FromBody] FilterModel model)
        {
            try
            {
                if (model.StartTime > model.EndTime)
                {
                    logger.Error("Invalid data");
                    return BadRequest();
                }
                var userId = HttpContext.CurrentUserId();
                var userRole = HttpContext.CurrentUserRole();
                var memberHasResource = await (from urm in _dBRepository.Context.Set<UserResourceMappingEntity>()
                                         join b in _dBRepository.Context.Set<BranchEntity>()
                                         on urm.BranchId equals b.Id
                                         where urm.UserId == userId && b.Code == model.BranchCode
                                         select new
                                         {
                                             UserId = urm.UserId,
                                             Code = b.Code
                                         })
                                            .AnyAsync();

                if (userRole == UserRole.Member && !memberHasResource)
                {
                    return Ok(new CustomResponse
                    {
                        Result = new List<FilterResult>(),
                        Message = "Bạn không có quyền truy cập tới tài nguyên này."
                    });
                }

                var buildInData = new List<FilterResult>()
                {
                    new FilterResult
                    {
                        Level = SatisfactionLevel.VeryBad,
                        Description = "Rất tệ",
                        Count = 0
                    },
                    new FilterResult
                    {
                        Level = SatisfactionLevel.Bad,
                        Description = "Tệ",
                        Count = 0
                    },
                    new FilterResult
                    {
                        Level = SatisfactionLevel.Acceptable,
                        Description = "Bình thường",
                        Count = 0
                    },
                    new FilterResult
                    {
                        Level = SatisfactionLevel.Good,
                        Description = "Tốt",
                        Count = 0
                    },
                    new FilterResult
                    {
                        Level = SatisfactionLevel.Perfect,
                        Description = "Hoàn hảo",
                        Count = 0
                    },
                };
                var dataByCode = await _dBRepository.Context.Set<CommentResponseEntity>()
                        .Include(a => a.UserBillEntity)
                        .Where(a => !a.IsDeleted
                                    && (userRole == UserRole.Admin
                                            ? (string.IsNullOrEmpty(model.BranchCode) || model.BranchCode.ToLower() == a.UserBillEntity.BranchCode.ToLower())
                                            : (!string.IsNullOrEmpty(model.BranchCode) && model.BranchCode.ToLower() == a.UserBillEntity.BranchCode.ToLower()))
                                    && a.CreatedTime >= model.StartTime
                                    && a.CreatedTime <= model.EndTime)
                        .GroupBy(a => a.Level)
                        .Select(a => new FilterResult
                        {
                            Level = a.Key,
                            Description = a.Key == SatisfactionLevel.VeryBad ? "Rất tệ"
                                        : a.Key == SatisfactionLevel.Bad ? "Tệ"
                                        : a.Key == SatisfactionLevel.Acceptable ? "Bình thường"
                                        : a.Key == SatisfactionLevel.Good ? "Tốt"
                                        : a.Key == SatisfactionLevel.Perfect ? "Hoàn hảo"
                                        : string.Empty,
                            Count = a.Count()
                        })
                        .ToListAsync();

                var result = from b in buildInData
                             join d in dataByCode
                             on b.Level equals d.Level
                             into data
                             from s in data.DefaultIfEmpty()
                             select new FilterResult
                             {
                                 Level = s == null ? b.Level : s.Level,
                                 Description = s == null ? b.Description : s.Description,
                                 Count = s == null ? b.Count : s.Count
                             };
                auditService.AddAudit(AuditAction.Filter);
                return Ok(new CustomResponse
                {
                    Result = result.ToList(),
                    Message = ""
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error filtering report. Message: {ex.Message}", ex);
                throw;
            }

        }

        [HttpPost("filterlevel")]
        [Permission(new UserRole[] { UserRole.Admin, UserRole.Member })]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<FilterLevelResult>))]
        public async Task<IActionResult> GetReportByLevel([FromBody] FilterByLevelModel model)
        {
            try
            {
                var userId = HttpContext.CurrentUserId();
                var userRole = HttpContext.CurrentUserRole();
                var memberHasResource = await (from urm in _dBRepository.Context.Set<UserResourceMappingEntity>()
                                               join b in _dBRepository.Context.Set<BranchEntity>()
                                               on urm.BranchId equals b.Id
                                               where urm.UserId == userId && b.Code == model.BranchCode
                                               select new
                                               {
                                                   UserId = urm.UserId,
                                                   Code = b.Code
                                               })
                                            .AnyAsync();

                if (userRole == UserRole.Member && !memberHasResource)
                {
                    return Ok(new CustomResponse
                    {
                        Result = null,
                        Message = "Bạn không có quyền truy cập tới tài nguyên này."
                    });
                }

                var data = await _dBRepository.Context.Set<CommentResponseEntity>()
                    .Include(a => a.UserBillEntity)
                    .Where(a => !a.IsDeleted
                        && a.CreatedTime >= model.StartTime
                        && a.CreatedTime <= model.EndTime
                        && ((userRole == UserRole.Admin && string.IsNullOrEmpty(model.BranchCode)) || model.BranchCode.ToLower() == a.UserBillEntity.BranchCode.ToLower())
                        && model.Level == a.Level)
                    .Select(e => new
                    {
                        UserComments = new
                        {
                            Comments = JsonConvert.DeserializeObject<List<UserComment>>(e.Comments),
                            CustomerName = e.UserBillEntity.CustomerName,
                            CustomerCode = e.UserBillEntity.CustomerCode,
                            Phone = e.UserBillEntity.Phone,
                            //Service = JsonConvert.DeserializeObject<List<BranchService>>(e.UserBillEntity.Service),
                            BranchCode = e.UserBillEntity.BranchCode,
                            BranchAddress = e.UserBillEntity.BranchAddress,
                            BillCode = e.UserBillEntity.BillCode,
                            StartTime = e.UserBillEntity.StartTime
                        },
                        OtherComments = new
                        {
                            Id = e.Id,
                            Content = e.OtherComment,
                            CustomerName = e.UserBillEntity.CustomerName,
                            CustomerCode = e.UserBillEntity.CustomerCode,
                            Phone = e.UserBillEntity.Phone,
                            //Service = JsonConvert.DeserializeObject<List<BranchService>>(e.UserBillEntity.Service),
                            BranchCode = e.UserBillEntity.BranchCode,
                            BranchAddress = e.UserBillEntity.BranchAddress,
                            BillCode = e.UserBillEntity.BillCode,
                            StartTime = e.UserBillEntity.StartTime
                        }
                    })
                    .ToListAsync();

                var userComments = data.Select(a => a.UserComments).Where(a => a.Comments != null && a.Comments.Any()).SelectMany(a => a.Comments).GroupBy(a => new { a.Id, a.Content }).Select(e => new DetailUserComment
                {
                    Id = e.Key.Id,
                    Content = e.Key.Content,
                    Count = e.Count(),
                    CreatedBy = data.Select(a => a.UserComments).Where(a => a.Comments.Select(a => a.Id).Contains(e.Key.Id)).Select(a => new UserCommentResult
                    {
                        CustomerName = a.CustomerName,
                        CustomerCode = a.CustomerCode,
                        Phone = a.Phone,
                        //Service = a.Service,
                        BranchCode = a.BranchCode,
                        BranchAddress = a.BranchAddress,
                        BillCode = a.BillCode,
                        StartTime = a.StartTime
                    }).ToList()
                }).ToList();

                var filterOtherComments = data.Select(a => a.OtherComments).Where(a => !string.IsNullOrEmpty(a.Content));
                var otherComments = filterOtherComments.Select(a => new DetailOtherComment
                {
                    Id = a.Id,
                    Content = a.Content,
                    Count = filterOtherComments.Count(x => x.Content.Trim().Equals(a.Content.Trim(), StringComparison.OrdinalIgnoreCase)),
                    CreatedBy = filterOtherComments.Select(a => new UserCommentResult
                    {
                        CustomerName = a.CustomerName,
                        CustomerCode = a.CustomerCode,
                        Phone = a.Phone,
                        //Service = a.Service,
                        BranchCode = a.BranchCode,
                        BranchAddress = a.BranchAddress,
                        BillCode = a.BillCode,
                        StartTime = a.StartTime
                    }).First()
                }).ToList();
                auditService.AddAudit(AuditAction.FilterByLevel);
                return Ok(new CustomResponse
                {
                    Result = new FilterLevelResult
                    {

                        UserComments = userComments,
                        OtherComments = otherComments
                    },
                    Message = ""
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error filtering by level. Message: {ex.Message}", ex);
                throw;
            }
        }
        [HttpPost("export")]
        [Permission(new UserRole[] { UserRole.Admin, UserRole.Member })]
        public async Task<IActionResult> Export([FromBody] FilterModel model)
        {
            try
            {
                var userId = HttpContext.CurrentUserId();
                var userRole = HttpContext.CurrentUserRole();
                var memberHasResource = await (from urm in _dBRepository.Context.Set<UserResourceMappingEntity>()
                                               join b in _dBRepository.Context.Set<BranchEntity>()
                                               on urm.BranchId equals b.Id
                                               where urm.UserId == userId && b.Code == model.BranchCode
                                               select new
                                               {
                                                   UserId = urm.UserId,
                                                   Code = b.Code
                                               })
                                            .AnyAsync();

                if (userRole == UserRole.Member && !memberHasResource)
                {
                    return Ok(new CustomResponse
                    {
                        Result = null,
                        Message = "Bạn không có quyền truy cập tới tài nguyên này."
                    });
                }
                var result = await _dBRepository.Context.Set<CommentResponseEntity>().Include(a => a.UserBillEntity)
                    .Where(a => !a.IsDeleted
                            && (string.IsNullOrEmpty(model.BranchCode) || model.BranchCode == a.UserBillEntity.BranchCode)
                            && a.CreatedTime >= model.StartTime
                            && a.CreatedTime <= model.EndTime)
                    .Select(a => new
                    {
                        Id = a.CreatedById,
                        a.UserBillEntity.CustomerName,
                        a.UserBillEntity.CustomerCode,
                        a.UserBillEntity.BranchCode,
                        a.UserBillEntity.BranchAddress,
                        a.UserBillEntity.Phone,
                        a.UserBillEntity.BillCode,
                        a.UserBillEntity.StartTime,
                        Services = JsonConvert.DeserializeObject<List<BranchService>>(a.UserBillEntity.Service),
                        //Doctor = JsonConvert.DeserializeObject<List<BranchService>>(a.UserBillEntity.Service).Doctor,
                        //ServiceName = JsonConvert.DeserializeObject<List<BranchService>>(a.UserBillEntity.Service).Name,
                        //Amount = JsonConvert.DeserializeObject<List<BranchService>>(a.UserBillEntity.Service).Amount,
                        //UnitPrice = JsonConvert.DeserializeObject<List<BranchService>>(a.UserBillEntity.Service).UnitPrice,
                        Level = a.Level,
                        LevelName = a.Level == SatisfactionLevel.VeryBad ? "Rất tệ"
                                        : a.Level == SatisfactionLevel.Bad ? "Tệ"
                                        : a.Level == SatisfactionLevel.Acceptable ? "Bình thường"
                                        : a.Level == SatisfactionLevel.Good ? "Tốt"
                                        : a.Level == SatisfactionLevel.Perfect ? "Hoàn hảo"
                                        : string.Empty,
                        Comment = JsonConvert.DeserializeObject<List<UserComment>>(a.Comments),
                        OtherComment = a.OtherComment
                    })
                    .ToListAsync();

                var finalResult = result.SelectMany(a => a.Services?.Select(b => new
                {
                    a.Id,
                    a.CustomerName,
                    a.CustomerCode,
                    a.BranchCode,
                    a.BranchAddress,
                    a.Phone,
                    a.BillCode,
                    a.StartTime,
                    b.Doctor,
                    b.Name,
                    b.UnitPrice,
                    b.Amount,
                    a.Level,
                    a.LevelName,
                    a.Comment,
                    a.OtherComment
                })).ToList();
                auditService.AddAudit(AuditAction.Export);
                return Ok(new CustomResponse
                {
                    Result = finalResult,
                    Message = "Xuất báo cáo thành công."
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error exporting report. {ex.Message}", ex);
                throw;
            }
        }
    }

}
