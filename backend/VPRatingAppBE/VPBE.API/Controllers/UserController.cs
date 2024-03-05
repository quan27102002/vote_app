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

namespace VPBE.API.Controllers
{
    public class UserController : APIBaseController
    {
        private readonly IDBRepository _dBRepository;
        private readonly ITokenService _tokenService;
        private readonly IConfiguration _configuration;

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
                var result = new UserLoginResult();
                var claims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, request.Username),
                    new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                    new Claim("role", user.UserRole.ToString())
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
        [Role(new UserRole[] { UserRole.Admin })]
        public async Task<IActionResult> Register([FromBody] RegisterUserRequest request)
        {
            try
            {
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
        [Role(new UserRole[] { UserRole.Admin })]
        public async Task<IActionResult> GetAllUsers()
        {
            try
            {
                var users = await _dBRepository.Context.Set<UserEntity>().Select(a => new UserDtos
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
        public async Task<IActionResult> LogOut()
        {
            try
            {
                var userId = Guid.Parse(HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier));
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
                    CreatedOn = DateTime.Now,
                };
                await _dBRepository.AddAsync(newTokenBlacklist);
                await _dBRepository.SaveChangesAsync();

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
                    CreatedOn = DateTime.Now,
                };
                await _dBRepository.AddAsync(newTokenBlacklist);
                await _dBRepository.SaveChangesAsync();

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
    }
}
