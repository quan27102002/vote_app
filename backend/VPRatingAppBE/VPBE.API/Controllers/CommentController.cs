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
using VPBE.Service.Interfaces;

namespace VPBE.API.Controllers
{
    public class CommentController : APIBaseController
    {
        private readonly IDBRepository _dBRepository;

        public CommentController(IDBRepository dBRepository)
        {
            this._dBRepository = dBRepository;
        }
        [HttpGet("getallcomments")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<List<ListComment>>))]
        [Role(new UserRole[] { UserRole.Admin, UserRole.Guest })]
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
        [Role(new UserRole[] { UserRole.Admin, UserRole.Guest })]
        public async Task<IActionResult> SubmitComment([FromBody] SubmitCommentRequest request)
        {
            try
            {
                var commentsInDb = await _dBRepository.Context.Set<CommentEntity>().Where(a => !a.IsDeleted && a.Level == request.Level).Select(a => a.Id).ToListAsync();
                if (!request.Comments.Any(x => commentsInDb.Contains(x.Id)))
                {
                    logger.Error("Mismatch data");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "Mismatch data"
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
                        Message = "Mismatch data"
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

                return Ok(new CustomResponse
                {
                    Result = true,
                    Message = "Success"
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error submit comment for bill code {request.UserBillId}. Message: {ex.Message}", ex);
                throw;
            }
        }
        [HttpPost("edit")]
        [Role(new UserRole[] { UserRole.Admin })]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<bool>))]
        public async Task<IActionResult> Edit([FromBody] EditCommentRequest request)
        {
            try
            {
                
                var comments = await _dBRepository.Context.Set<CommentEntity>().Where(a => !a.IsDeleted && a.Level == request.Level).ToListAsync();
                if (!comments.Any())
                {
                    logger.Error($"Comment at level {request.Level} not existed");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "Comments not found"
                    });
                }
                foreach (var comment in comments)
                {
                    var content = request.Comments.First(a => a.Id == comment.Id).Content;
                    comment.Content = content;
                }
                
                await _dBRepository.SaveChangesAsync();

                return Ok(new CustomResponse
                {
                    Result = true,
                    Message = "Success"
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
