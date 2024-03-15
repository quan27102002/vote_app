using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Annotations;
using System.Runtime.InteropServices;
using System.Security.Claims;
using VPBE.API.Controllers.Base;
using VPBE.Domain.Attributes;
using VPBE.Domain.Dtos;
using VPBE.Domain.Dtos.Users;
using VPBE.Domain.Entities;
using VPBE.Domain.Models.Users;
using VPBE.Domain.Utils;
using VPBE.Domain.Interfaces;
using VPBE.Domain.Models.Tokens;
using IdentityModel;
using VPBE.Domain.Extensions;
using System;
using VPBE.Domain.Audit;

namespace VPBE.API.Controllers
{
    public class UserController : ApiBaseController
    {
        private readonly IDBRepository _dBRepository;
        private readonly ITokenService _tokenService;
        private readonly IConfiguration _configuration;
        public static readonly object UserObjectKey = new();
        public UserController(IDBRepository dBRepository, ITokenService tokenService, IConfiguration configuration)
        {
            this._dBRepository = dBRepository;
            this._tokenService = tokenService;
            this._configuration = configuration;
        }
        [HttpPost("login")]
        [AllowAnonymous]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<UserLoginResult>))]
        public async Task<IActionResult> Login([FromBody] UserLoginRequest request)
        {
            try
            {
                var user = await _dBRepository.Context.Set<UserEntity>().Where(a => a.UserStatus == UserStatus.Active && a.UserName.ToLower() == request.Username.ToLower()).FirstOrDefaultAsync();
                if (user == null)
                {
                    logger.Error($"User '{request.Username}' not found.");
                    return Ok(new CustomResponse
                    {
                        Result = null,
                        Message = "Người dùng không tồn tại trong hệ thống."
                    });
                }
                bool checkPassword = PasswordUtils.VerifyPassword(request.Password, user.Password, user.PasswordSalt);
                if (!checkPassword)
                {
                    logger.Error($"Wrong password for user {request.Username}");
                    return Ok(new CustomResponse
                    {
                        Result = null,
                        Message = "Sai mật khẩu."
                    });
                }
                if (!string.IsNullOrEmpty(user.AccessToken) && !string.IsNullOrEmpty(user.RefreshToken))
                {
                    var invalidToken = new TokenBlacklistEntity
                    {
                        AccessToken = user.AccessToken,
                        RefreshToken = user.RefreshToken,
                        IssuedById = user.Id,
                        CreatedOn = DateTime.Now,
                        ExpiredAt = user.RefreshTokenExpireTime
                    };

                    await _dBRepository.AddAsync(invalidToken);
                    await _dBRepository.SaveChangesAsync();
                }

                var result = new UserLoginResult();
                var claims = new List<Claim>
                {
                    new Claim(JwtClaimTypes.Name, request.Username),
                    new Claim(JwtClaimTypes.Id, user.Id.ToString()),
                    new Claim(JwtClaimTypes.Role, user.UserRole.ToString()),
                    new Claim(JwtClaimTypes.PreferredUserName, user.DisplayName)
                };
                var accessToken = _tokenService.GenerateAccessToken(claims);
                var refreshToken = _tokenService.GenerateRefreshToken();
                user.RefreshToken = refreshToken;
                user.AccessToken = accessToken;
                user.AccessTokenExpireTime = DateTime.Now.AddMinutes(Double.Parse(_configuration["JwtAuthentication:AccessTokenExpireInMinutes"]));
                user.RefreshTokenExpireTime = DateTime.Now.AddMinutes(Double.Parse(_configuration["JwtAuthentication:RefreshTokenExpireInMinutes"]));

                await _dBRepository.SaveChangesAsync();

                result.AccessToken = accessToken;
                result.RefreshToken = refreshToken;
                result.Role = user.UserRole;
                result.DisplayName = user.DisplayName;
                result.BranchCode = user.Code;
                result.BranchAddress = user.BranchAddress;
                result.UserId = user.Id;

                auditService.AddAudit(AuditAction.SignIn);

                await HttpContext.AuthenticateAsync();

                return Ok(new CustomResponse
                {
                    Result = result,
                    Message = "Đăng nhập thành công."
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error logging in to system. Message: {ex.Message}", ex);
                throw;
            }
        }

        [HttpPost("register")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<bool>))]
        [Permission(new UserRole[] { UserRole.Admin })]
        public async Task<IActionResult> Register([FromBody] RegisterUserRequest request)
        {
            try
            {
                if ((int)request.Role <= 0 || (int)request.Role > 3)
                {
                    logger.Error($"Invalid role");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "Role không hợp lệ"
                    });
                }
                var checkUserName = await _dBRepository.Context.Set<UserEntity>().AnyAsync(a => a.UserName.ToLower() == request.Username.ToLower());
                if (checkUserName)
                {
                    logger.Error($"Username {request.Username} already exists.");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "Tên đăng nhập đã tồn tại."
                    });
                }
                var newUser = new UserEntity
                {
                    Id = Guid.NewGuid(),
                    UserName = request.Username,
                    Email = request.Email,
                    Code = request.Code,
                    DisplayName = request.DisplayName,
                    BranchAddress = request.BranchAddress,
                    Password = PasswordUtils.HashPassword(request.Password, out var salt),
                    PasswordSalt = salt,
                    UserRole = request.Role,
                    UserStatus = UserStatus.Active,
                    CreatedOn = DateTime.Now
                };
                if (request.Role != UserRole.Admin)
                {
                    var branchId = await _dBRepository.Context.Set<BranchEntity>().Where(a => a.Code.ToLower() == request.Code.ToLower()).Select(a => a.Id).FirstOrDefaultAsync();
                    if (branchId == Guid.Empty)
                    {
                        logger.Error($"Code {request.Code} not existed.");
                        return Ok(new CustomResponse
                        {
                            Result = false,
                            Message = "Mã cơ sở không tồn tại"
                        });
                    }
                    var newUrm = new UserResourceMappingEntity
                    {
                        UserId = newUser.Id,
                        BranchId = branchId
                    };
                    await _dBRepository.AddAsync(newUrm);
                }

                await _dBRepository.AddAsync(newUser);

                await _dBRepository.SaveChangesAsync();
                auditService.AddAudit(AuditAction.RegisterUser);
                return Ok(new CustomResponse
                {
                    Result = true,
                    Message = "Đăng kí thành công."
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error add new user. Message: {ex.Message}", ex);
                throw;
            }
        }
        [HttpPost("get")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<UserDtos>))]
        [Permission(new UserRole[] { UserRole.Admin })]
        public async Task<IActionResult> GetAllUsers()
        {
            try
            {
                var users = await _dBRepository.Context.Set<UserEntity>().Where(a => a.UserRole != UserRole.SuperUser).Select(a => new UserDtos
                {
                    DisplayName = a.DisplayName,
                    Email = a.Email,
                    UserName = a.UserName,
                    Code = a.Code,
                    BranchAddress = a.BranchAddress,
                    UserRole = a.UserRole == UserRole.Admin ? "Admin" : a.UserRole == UserRole.Member ? "Quản lý cơ sở" : a.UserRole == UserRole.Guest ? "Thiết bị" : "",
                    UserStatus = a.UserStatus == UserStatus.Active ? "Đang hoạt động" : "Không hoạt động",
                    CreatedOn = a.CreatedOn
                }).ToListAsync();

                auditService.AddAudit(AuditAction.ViewAllUsers);

                return Ok(new CustomResponse
                {
                    Result = users,
                    Message = ""
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error getting all users. {ex.Message}", ex);
                throw;
            }
        }
        [HttpPost("signout")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<bool>))]
        [Permission(new UserRole[] { UserRole.Admin, UserRole.Member, UserRole.Guest })]
        public async Task<IActionResult> LogOut()
        {
            try
            {
                var userId = HttpContext.CurrentUserId();
                var user = await _dBRepository.Context.Set<UserEntity>().Where(u => u.Id == userId && u.UserStatus == UserStatus.Active).FirstOrDefaultAsync();
                if (user == null)
                {
                    logger.Error($"User not found, id: {userId}");
                    return NoContent();
                }
                var newTokenBlacklist = new TokenBlacklistEntity
                {
                    AccessToken = user.AccessToken,
                    RefreshToken = user.RefreshToken,
                    IssuedById = user.Id,
                    CreatedOn = DateTime.Now,
                    ExpiredAt = user.RefreshTokenExpireTime
                };
                await _dBRepository.AddAsync(newTokenBlacklist);
                await _dBRepository.SaveChangesAsync();
                auditService.AddAudit(AuditAction.SignOut);
                return Ok(new CustomResponse
                {
                    Result = true,
                    Message = "Đăng xuất thành công."
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error logging out. Message: {ex.Message}", ex);
                throw;
            }
        }

        [HttpPost("refreshtoken")]
        [AllowAnonymous]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<RefreshTokenRequest>))]
        public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequest request)
        {
            try
            {
                string accessToken = request.AccessToken;
                string refreshToken = request.RefreshToken;
                if (string.IsNullOrEmpty(accessToken) || string.IsNullOrEmpty(refreshToken))
                {
                    logger.Error("Invalid token");
                    return BadRequest();
                }
                //if (!HttpContext.Response.Headers["IS-TOKEN-EXPIRED"].Any())
                //{
                //    logger.Error("Token expired header is empty");
                //    return BadRequest();
                //}
                var principal = _tokenService.GetPrincipalFromExpiredToken(accessToken);
                var username = principal.Identity.Name;
                var user = await _dBRepository.Context.Set<UserEntity>().Where(u => u.UserName == username && u.UserStatus == UserStatus.Active).FirstOrDefaultAsync();
                if (user is null || user.RefreshToken != refreshToken || user.RefreshTokenExpireTime < DateTime.Now)
                {
                    logger.Error($"Invalid user data");
                    return Ok(new CustomResponse
                    {
                        Result = null,
                        Message = "Invalid user data"
                    });
                }
                var isInBlacklist = await _dBRepository.Context.Set<TokenBlacklistEntity>().AnyAsync(a => a.AccessToken == request.AccessToken && a.RefreshToken == request.RefreshToken);
                if (isInBlacklist)
                {
                    user.RefreshToken = string.Empty;
                    user.RefreshTokenExpireTime = default;
                    user.AccessToken = string.Empty;
                    user.AccessTokenExpireTime = default;

                    await _dBRepository.SaveChangesAsync();
                    logger.Error($"Untrusted refresh token request.");
                    return NoContent();

                }
                var newAccessToken = _tokenService.GenerateAccessToken(principal.Claims.ToList());
                var newRefreshToken = _tokenService.GenerateRefreshToken();
                user.AccessToken = newAccessToken;
                user.RefreshToken = newRefreshToken;
                user.AccessTokenExpireTime = DateTime.Now.AddMinutes(Double.Parse(_configuration["JwtAuthentication:AccessTokenExpireInMinutes"]));
                user.RefreshTokenExpireTime = DateTime.Now.AddMinutes(Double.Parse(_configuration["JwtAuthentication:RefreshTokenExpireInMinutes"]));
                var newTokenBlacklist = new TokenBlacklistEntity
                {
                    AccessToken = request.AccessToken,
                    RefreshToken = request.RefreshToken,
                    IssuedById = user.Id,
                    CreatedOn = DateTime.Now,
                    ExpiredAt = user.RefreshTokenExpireTime
                };
                await _dBRepository.AddAsync(newTokenBlacklist);
                await _dBRepository.SaveChangesAsync();
                auditService.AddAudit(AuditAction.RefreshToken);
                return Ok(new CustomResponse
                {
                    Result = new RefreshTokenRequest
                    {
                        AccessToken = newAccessToken,
                        RefreshToken = newRefreshToken
                    },
                    Message = "Success"
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error refreshing token. Message: {ex.Message}", ex);
                throw;
            }
        }
        [HttpPost("getinvalidatetoken")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<List<TokenBlacklistEntity>>))]
        [Permission(isSuperUser: true)]
        public async Task<IActionResult> GetInvalidateToken([FromBody] FilterToken model)
        {
            try
            {
                var items = await _dBRepository.Context.Set<TokenBlacklistEntity>()
                    .Include(a => a.IssuedBy)
                    .Where(a =>
                        (model.EndTime == DateTime.MinValue && model.StartTime == DateTime.MinValue) ||
                        (a.CreatedOn >= model.StartTime && a.CreatedOn <= model.EndTime))
                    .OrderByDescending(a => a.CreatedOn)
                    .Select(a => new
                    {
                        Id = a.Id,
                        IssuedById = a.IssuedById,
                        DisplayName = a.IssuedBy.DisplayName,
                        Code = a.IssuedBy.Code,
                        UserRole = a.IssuedBy.UserRole,
                        CreatedOn = a.CreatedOn,
                        ExpiredAt = a.ExpiredAt,
                        AccessToken = a.AccessToken,
                        RefreshToken = a.RefreshToken
                    })
                    .ToListAsync();
                auditService.AddAudit(AuditAction.ViewInvalidateToken);
                return Ok(new CustomResponse
                {
                    Result = items,
                    Message = ""
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error getting invalidate tokens. Message: {ex.Message}", ex);
                throw;
            }
        }
        [HttpPost("manageaccount/{action}/{id}")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<List<bool>>))]
        [Permission(isSuperUser: true)]
        public async Task<IActionResult> ActivateOrDeactivateAccount([FromRoute] UserStatus action, Guid id)
        {
            try
            {
                var user = await _dBRepository.Context.Set<UserEntity>().Where(a => a.Id == id).FirstOrDefaultAsync();
                if (user == null)
                {
                    logger.Error($"User '{id}' not found.");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "User not existed in system."
                    });
                }
                user.UserStatus = action;
                await _dBRepository.SaveChangesAsync();
                auditService.AddAudit(action == UserStatus.Inactive ? AuditAction.DeactivateAccount : AuditAction.ActivateAccount);
                return Ok(new CustomResponse
                {
                    Result = true,
                    Message = action == UserStatus.Inactive ? "The user is deactivated." : "The user is activated"
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error managing account. Action: {action}, Message: {ex.Message}");
                throw;
            }
        }
        //[HttpPost("edit")]
        //public async Task<IActionResult> EditAccount([FromRoute] Guid id)
        //{
        //    try
        //    {
        //        var user = await _dBRepository.Context.Set<UserEntity>().Where(a => a.Id == id).FirstOrDefaultAsync();
        //        if (user == null)
        //        {
        //            logger.Error($"User '{id}' not found.");
        //            return Ok(new CustomResponse
        //            {
        //                Result = false,
        //                Message = "User not existed in system."
        //            });
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        logger.Error($"Error editing account. Message: {ex.Message}");
        //        throw;
        //    }
        //}
    }
}
