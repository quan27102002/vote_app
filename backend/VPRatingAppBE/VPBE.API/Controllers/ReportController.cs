using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Swashbuckle.AspNetCore.Annotations;
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
        [Role(new UserRole[] { UserRole.Admin })]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<FilterResult>))]
        public async Task<IActionResult> GetReport([FromBody] FilterModel model)
        {
            try
            {
                if (model.StartTime > model.EndTime)
                {
                    logger.Error("Invalid data");
                    return BadRequest();
                }
                if (!model.BranchCode.Any())
                {
                    var data = await _dBRepository.Context.Set<CommentResponseEntity>()
                        .Where(a => !a.IsDeleted && a.CreatedTime >= model.StartTime && a.CreatedTime <= model.EndTime)
                        //.Select(a => new
                        //{
                        //    Id = a.Id,
                        //    Level = a.Level,
                        //    CommentType = a.CommentType,
                        //    OtherComment = a.OtherComment,
                        //    Comments = JsonConvert.DeserializeObject<List<UserComment>>(a.Comments),
                        //})
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
                    return Ok(new CustomResponse
                    {
                        Result = data,
                        Message = ""
                    });
                }
                var dataByCode = await _dBRepository.Context.Set<CommentResponseEntity>()
                        .Include(a => a.UserBillEntity)
                        .Where(a => !a.IsDeleted && model.BranchCode.Contains(a.UserBillEntity.BranchCode) && a.CreatedTime >= model.StartTime && a.CreatedTime <= model.EndTime)
                        //.Select(a => new
                        //{
                        //    Id = a.Id,
                        //    Level = a.Level,
                        //    CommentType = a.CommentType,
                        //    OtherComment = a.OtherComment,
                        //    Comments = JsonConvert.DeserializeObject<List<UserComment>>(a.Comments),
                        //})
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
                return Ok(new CustomResponse
                {
                    Result = dataByCode,
                    Message = ""
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error filtering report. Message: {ex.Message}", ex);
                throw;
            }
        }
    }

}
