using Microsoft.AspNetCore.Authentication;
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
using VPBE.Service.Interfaces;

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
                        Message = "User not found"
                    });
                }
                bool checkPassword = PasswordUtils.VerifyPassword(request.Password, user.Password, user.PasswordSalt);
                if (!checkPassword)
                {
                    logger.Error($"Wrong password for user {request.Username}");
                    return Ok(new CustomResponse
                    {
                        Result = null,
                        Message = "Wrong password"
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

                await HttpContext.AuthenticateAsync();

                return Ok(new CustomResponse
                {
                    Result = result,
                    Message = "Success"
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
                        Message = "Username already exists."
                    });
                }
                var newUser = new UserEntity
                {
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

                await _dBRepository.AddAsync(newUser);
                await _dBRepository.SaveChangesAsync();
                return Ok(new CustomResponse
                {
                    Result = true,
                    Message = "Success"
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error add new user. Message: {ex.Message}", ex);
                throw;
            }
        }

        [HttpPost("refreshtoken")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<RefreshTokenRequest>))]
        public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequest request)
        {
            try
            {
                string accessToken = request.AccessToken;
                string refreshToken = request.RefreshToken;
                var principal = _tokenService.GetPrincipalFromExpiredToken(accessToken);
                var username = principal.Identity.Name;
                var user = await _dBRepository.Context.Set<UserEntity>().Where(u => u.UserName == username && u.UserStatus == UserStatus.Active).FirstOrDefaultAsync();
                if (user is null || user.RefreshToken != refreshToken || user.RefreshTokenExpireTime <= DateTime.Now)
                {
                    logger.Error($"Invalid user data");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "Invalid user data"
                    });
                }
                var newAccessToken = _tokenService.GenerateAccessToken(principal.Claims.ToList());
                var newRefreshToken = _tokenService.GenerateRefreshToken();
                user.AccessToken = newAccessToken;
                user.RefreshToken = newRefreshToken;
                user.AccessTokenExpireTime = DateTime.Now.AddMinutes(Double.Parse(_configuration["JwtAuthentication:AccessTokenExpireInMinutes"]));
                user.RefreshTokenExpireTime = DateTime.Now.AddMinutes(Double.Parse(_configuration["JwtAuthentication:RefreshTokenExpireInMinutes"]));
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
