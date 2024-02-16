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
using VPBE.Service.Interfaces;

namespace VPBE.API.Controllers
{
    public class ReportController : APIBaseController
    {
        private readonly IDBRepository _dBRepository;

        public ReportController(IDBRepository dBRepository)
        {
            this._dBRepository = dBRepository;
        }
        [HttpPost("filter")]
        [Role(new UserRole[] { UserRole.Admin, UserRole.Member })]
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
                var userId = HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
                var userRole = HttpContext.User.FindFirstValue(ClaimTypes.Role);
                var role = (UserRole)Enum.Parse(typeof(UserRole), userRole);
                var memberHasResource = await _dBRepository.Context.Set<UserResourceMappingEntity>()
                    .Include(a => a.BranchEntity)
                    .AnyAsync(a => a.UserId == Guid.Parse(userId) && a.BranchEntity.Code == model.BranchCode);

                if (role == UserRole.Member && !memberHasResource)
                {
                    return Ok(new CustomResponse
                    {
                        Result = null,
                        Message = "You don't have access to this resource"
                    });
                }

                if (role == UserRole.Admin)
                {
                    var data = await GetDataForAdmin(model);
                    return Ok(new CustomResponse
                    {
                        Result = data,
                        Message = ""
                    });
                }
                if (role == UserRole.Member)
                {
                    var dataByCode = await GetDataForMember(model);
                    return Ok(new CustomResponse
                    {
                        Result = dataByCode,
                        Message = ""
                    });
                }
            }
            catch (Exception ex)
            {
                logger.Error($"Error filtering report. Message: {ex.Message}", ex);
                throw;
            }

            return NoContent();
        }

        private async Task<List<FilterResult>> GetDataForAdmin(FilterModel model)
        {
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
                                && (string.IsNullOrEmpty(model.BranchCode) || model.BranchCode.ToLower() == a.UserBillEntity.BranchCode.ToLower())
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

            return result.ToList();

        }

        private async Task<List<FilterResult>> GetDataForMember(FilterModel model)
        {
            var data = new List<FilterResult>();
            if (!string.IsNullOrEmpty(model.BranchCode))
            {
                var dataByCode = await _dBRepository.Context.Set<CommentResponseEntity>()
                        .Include(a => a.UserBillEntity)
                        .Where(a => !a.IsDeleted && model.BranchCode.ToLower() == a.UserBillEntity.BranchCode.ToLower() && a.CreatedTime >= model.StartTime && a.CreatedTime <= model.EndTime)
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

                return dataByCode;
            }

            return data;
        }

        [HttpPost("filterlevel")]
        [Role(new UserRole[] { UserRole.Admin, UserRole.Member })]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<FilterLevelResult>))]
        public async Task<IActionResult> GetReportByLevel([FromBody] FilterByLevelModel model)
        {
            try
            {
                var userId = HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
                var userRole = HttpContext.User.FindFirstValue(ClaimTypes.Role);
                var role = (UserRole)Enum.Parse(typeof(UserRole), userRole);
                var memberHasResource = await _dBRepository.Context.Set<UserResourceMappingEntity>()
                    .Include(a => a.BranchEntity)
                    .AnyAsync(a => a.UserId == Guid.Parse(userId) && a.BranchEntity.Code == model.BranchCode);

                if (role == UserRole.Member && !memberHasResource)
                {
                    return Ok(new CustomResponse
                    {
                        Result = null,
                        Message = "You don't have access to this resource"
                    });
                }

                var data = await _dBRepository.Context.Set<CommentResponseEntity>()
                    .Include(a => a.UserBillEntity)
                    .Where(a => !a.IsDeleted
                        && a.CreatedTime >= model.StartTime
                        && a.CreatedTime <= model.EndTime
                        && ((role == UserRole.Admin && string.IsNullOrEmpty(model.BranchCode)) || model.BranchCode.ToLower() == a.UserBillEntity.BranchCode.ToLower())
                        && model.Level == a.Level)
                    .Select(e => new
                    {
                        UserComments = new
                        {
                            Comments = JsonConvert.DeserializeObject<List<UserComment>>(e.Comments),
                            CustomerName = e.UserBillEntity.CustomerName,
                            CustomerCode = e.UserBillEntity.CustomerCode,
                            Phone = e.UserBillEntity.Phone,
                            Service = JsonConvert.DeserializeObject<BranchService>(e.UserBillEntity.Service),
                            Doctor = e.UserBillEntity.Doctor,
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
                            Service = JsonConvert.DeserializeObject<BranchService>(e.UserBillEntity.Service),
                            Doctor = e.UserBillEntity.Doctor,
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
                        Service = a.Service,
                        Doctor = a.Doctor,
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
                    Count = filterOtherComments.Count(),
                    CreatedBy = filterOtherComments.Select(a => new UserCommentResult
                    {
                        CustomerName = a.CustomerName,
                        CustomerCode = a.CustomerCode,
                        Phone = a.Phone,
                        Service = a.Service,
                        Doctor = a.Doctor,
                        BranchCode = a.BranchCode,
                        BranchAddress = a.BranchAddress,
                        BillCode = a.BillCode,
                        StartTime = a.StartTime
                    }).First()
                }).ToList();

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
        [Role(new UserRole[] { UserRole.Admin, UserRole.Member })]
        public async Task<IActionResult> Export([FromBody] FilterModel model)
        {
            try
            {
                var userId = HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
                var userRole = HttpContext.User.FindFirstValue(ClaimTypes.Role);
                var role = (UserRole)Enum.Parse(typeof(UserRole), userRole);
                var memberHasResource = await _dBRepository.Context.Set<UserResourceMappingEntity>()
                    .Include(a => a.BranchEntity)
                    .AnyAsync(a => a.UserId == Guid.Parse(userId) && a.BranchEntity.Code == model.BranchCode);

                if (role == UserRole.Member && !memberHasResource)
                {
                    return Ok(new CustomResponse
                    {
                        Result = null,
                        Message = "You don't have access to this resource"
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
                        CustomerName = a.UserBillEntity.CustomerName,
                        CustomerCode = a.UserBillEntity.CustomerCode,
                        a.UserBillEntity.BranchCode,
                        a.UserBillEntity.BranchAddress,
                        a.UserBillEntity.Phone,
                        a.UserBillEntity.BillCode,
                        a.UserBillEntity.StartTime,
                        a.UserBillEntity.Doctor,
                        ServiceName = JsonConvert.DeserializeObject<BranchService>(a.UserBillEntity.Service).Name,
                        Amount = JsonConvert.DeserializeObject<BranchService>(a.UserBillEntity.Service).Amount,
                        UnitPrice = JsonConvert.DeserializeObject<BranchService>(a.UserBillEntity.Service).UnitPrice,
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

                return Ok(new CustomResponse
                {
                    Result = result,
                    Message = "Success"
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
