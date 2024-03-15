using FluentValidation;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Swashbuckle.AspNetCore.Annotations;
using VPBE.API.Controllers.Base;
using VPBE.Domain.Attributes;
using VPBE.Domain.Dtos;
using VPBE.Domain.Dtos.Comments;
using VPBE.Domain.Entities;
using VPBE.Domain.Models.Comments;
using VPBE.Domain.Interfaces;
using VPBE.Domain.Audit;

namespace VPBE.API.Controllers
{
    public class CommentController : ApiBaseController
    {
        private readonly IDBRepository _dBRepository;

        public CommentController(IDBRepository dBRepository)
        {
            this._dBRepository = dBRepository;
        }
        [HttpGet("getallcomments")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<List<ListComment>>))]
        [Permission(new UserRole[] { UserRole.Admin, UserRole.Member, UserRole.Guest })]
        public async Task<IActionResult> GetAllComments()
        {
            try
            {
                var comments = await _dBRepository.Context.Set<CommentEntity>().Where(a => !a.IsDeleted)
                    .GroupBy(a => a.Level)
                    .Select(a => new
                    {
                        Level = a.Key,
                        Comments = a.Select(b => new CommentDto
                        {
                            Id = b.Id,
                            Level = b.Level,
                            CommentType = b.CommentType,
                            Content = b.Content
                        }).ToList()
                    })
                    .ToListAsync();
                auditService.AddAudit(AuditAction.ViewAllComments);
                return Ok(new CustomResponse
                {
                    Result = comments,
                    Message = ""
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error getting all comments. Message: {ex.Message}", ex);
                throw;
            }
        }
        [HttpGet("type/{type}")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<CommentDto>))]
        [Permission(new UserRole[] { UserRole.Admin, UserRole.Member, UserRole.Guest })]
        public async Task<IActionResult> GetByType([FromRoute] CommentType type)
        {
            try
            {
                var comments = await _dBRepository.Context.Set<CommentEntity>().Where(a => !a.IsDeleted && a.CommentType == type).Select(a => new CommentDto
                {
                    Id = a.Id,
                    Level = a.Level,
                    CommentType = a.CommentType,
                    Content = a.Content
                }).ToListAsync();
                auditService.AddAudit(AuditAction.ViewCommentsByType);
                return Ok(new CustomResponse
                {
                    Result = comments,
                    Message = ""
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error getting comments by type. Message: {ex.Message}", ex);
                throw;
            }
        }
        [HttpGet("level/{level}")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<CommentDto>))]
        [Permission(new UserRole[] { UserRole.Admin, UserRole.Member, UserRole.Guest })]
        public async Task<IActionResult> GetByLevel([FromRoute] SatisfactionLevel level)
        {
            try
            {
                var comments = await _dBRepository.Context.Set<CommentEntity>().Where(a => !a.IsDeleted && a.Level == level).Select(a => new CommentDto
                {
                    Id = a.Id,
                    Level = a.Level,
                    CommentType = a.CommentType,
                    Content = a.Content
                }).ToListAsync();
                auditService.AddAudit(AuditAction.ViewCommentsByType);
                return Ok(new CustomResponse
                {
                    Result = comments,
                    Message = ""
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error getting comments by level. Message: {ex.Message}", ex);
                throw;
            }
        }
        [HttpPost("submit")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<bool>))]
        [Permission(new UserRole[] { UserRole.Admin, UserRole.Member, UserRole.Guest })]
        public async Task<IActionResult> SubmitComment([FromBody] SubmitCommentRequest request)
        {
            try
            {
                var commentsInDb = await _dBRepository.Context.Set<CommentEntity>().Where(a => !a.IsDeleted && a.Level == request.Level).Select(a => a.Id).ToListAsync();

                var userBill = await _dBRepository.Context.Set<CommentResponseEntity>().Include(a => a.UserBillEntity).Where(a => !a.IsDeleted && a.UserBillEntity.Id == request.UserBillId).FirstOrDefaultAsync();
                if (userBill != null)
                {
                    logger.Error($"User bill {request.UserBillId} is existed");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "Hóa đơn đã đựoc đánh giá."
                    });
                }
                if (request.CommentType == CommentType.BuiltIn && !request.Comments.Any(x => commentsInDb.Contains(x.Id)))
                {
                    logger.Error("Mismatch data");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "Bình luận không khớp với cơ sở dữ liệu."
                    });
                }
                var checkMismatchData = (request.CommentType == CommentType.Mixed && string.IsNullOrEmpty(request.OtherComment))
                    || (request.CommentType == CommentType.BuiltIn && !string.IsNullOrEmpty(request.OtherComment))
                    || (request.CommentType == CommentType.Customized && request.Comments.Any());
                if (checkMismatchData)
                {
                    logger.Error("Mismatch data");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "Loại bình luận và nội dung không khớp với nhau."
                    });
                }
                var newComment = new CommentResponseEntity
                {
                    UserBillId = request.UserBillId,
                    Level = request.Level,
                    CommentType = request.CommentType,
                    OtherComment = request.OtherComment,
                    Comments = JsonConvert.SerializeObject(request.Comments)
                };
                await _dBRepository.AddAsync(newComment);

                await _dBRepository.SaveChangesAsync();
                auditService.AddAudit(AuditAction.SubmitComment);
                return Ok(new CustomResponse
                {
                    Result = true,
                    Message = "Đánh giá thành công."
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error submit comment for bill code {request.UserBillId}. Message: {ex.Message}", ex);
                throw;
            }
        }
        [HttpPost("edit")]
        [Permission(new UserRole[] { UserRole.Admin })]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<bool>))]
        public async Task<IActionResult> Edit([FromBody] EditCommentRequest request)
        {
            try
            {
                if (request.Comments.Any(a => string.IsNullOrEmpty(a.Content)))
                {
                    logger.Error($"Comment cannot be empty");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "Bình luận không được để trống."
                    });
                }
                var comments = await _dBRepository.Context.Set<CommentEntity>().Where(a => !a.IsDeleted && a.Level == request.Level).ToListAsync();
                if (!comments.Any())
                {
                    logger.Error($"Comment at level {request.Level} not existed");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "Bình luận không tồn tại."
                    });
                }
                foreach (var comment in request.Comments)
                {
                    var item = comments.FirstOrDefault(a => a.Id == comment.Id);
                    if (item == null) continue;
                    item.Content = comment.Content;
                }
                
                await _dBRepository.SaveChangesAsync();
                auditService.AddAudit(AuditAction.EditComment);
                return Ok(new CustomResponse
                {
                    Result = true,
                    Message = "Cập nhật bình luận thành công."
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error edit comment at level {request.Level}. Message: {ex.Message}", ex);
                throw;
            }
        }
    }
}
