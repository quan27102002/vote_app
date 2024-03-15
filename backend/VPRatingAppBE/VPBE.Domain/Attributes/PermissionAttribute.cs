using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Dtos;
using VPBE.Domain.Entities;
using VPBE.Domain.Logging;
using VPBE.Domain.Interfaces;
using VPBE.Domain.Extensions;
using Microsoft.Extensions.Logging;
using VPBE.Domain.Utils;

namespace VPBE.Domain.Attributes
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = true)]
    public class PermissionAttribute : Attribute, IAsyncActionFilter
    {
        private static readonly Logger _logger = LoggerHelper.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private string _resourceParamName;
        private string _resourceIdPath;
        private readonly IList<UserRole> _roles;
        private readonly bool _isSuperUser;
        public PermissionAttribute(UserRole[] roles)
        {
            _roles = roles ?? new UserRole[] { };
        }
        public PermissionAttribute(bool isSuperUser)
        {
            _isSuperUser = isSuperUser;
        }

        public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
        {
            if (context?.HttpContext.User.Identity != null && !context.HttpContext.User.Identity.IsAuthenticated)
            {
                _logger.Error("User is not authenticated");
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status401Unauthorized,
                    Status = StatusCodes.Status401Unauthorized,
                    Msg = ""
                });
                return;
            }
            var userId = context.HttpContext.CurrentUserId();
            var role = context.HttpContext.CurrentUserRole();
            List<Guid> resourceIds = GetResourceIds(context);
            var currentPath = context.HttpContext.Request.Path.ToString().ToLower();
            if (currentPath.Contains("/api"))
            {
                var dBRepository = context.HttpContext.RequestServices.GetRequiredService<IDBRepository>();
                var accessToken = await context.HttpContext.GetTokenAsync("access_token");
                if (!string.IsNullOrEmpty(accessToken))
                {
                    _logger.Info($"Start checking token for user id: {userId}");
                    var checkExist = await dBRepository.Context.Set<TokenBlacklistEntity>().AnyAsync(a => a.AccessToken == accessToken);
                    if (checkExist)
                    {
                        _logger.Error("Check token result: Invalid, force signout");
                        context.Result = new ObjectResult(new APIResponseDto
                        {
                            Code = StatusCodes.Status401Unauthorized,
                            Status = (int)SubStatus.ForceSignout,
                            Msg = "Tài khoản đã đăng nhập ở nơi khác."
                        });
                        return;
                    }
                    _logger.Info($"Finish checking token for user id: {userId}");
                    _logger.Info($"Start checking user status for user id: {userId}");
                    var status = await dBRepository.Context.Set<UserEntity>().Where(a => a.Id == userId).Select(a => a.UserStatus).FirstOrDefaultAsync();
                    if (status == UserStatus.Inactive)
                    {
                        _logger.Error($"Check token result: Invalid, force signout for user id: {userId}");
                        context.Result = new ObjectResult(new APIResponseDto
                        {
                            Code = StatusCodes.Status400BadRequest,
                            Status = (int)SubStatus.AccountDeactivated,
                            Msg = "Tài khoản đã bị vô hiệu hóa."
                        });
                        return;
                    }
                    _logger.Info($"Finish checking user status for user id: {userId}");
                }
            }
            
            
            if (_isSuperUser || role == UserRole.SuperUser)
            {
                _logger.Warn($"No need to check permission for user {userId}");
                await next();
                return;
            }
            if (_roles.Any() && !_roles.Contains(role))
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status403Forbidden,
                    Status = StatusCodes.Status403Forbidden,
                    Msg = ""
                });
                return;
            }

            await next();
        }

        private List<Guid> GetResourceIds(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context)
        {
            var resourceIds = new List<Guid>();
            try
            {
                if (_resourceParamName != null)
                {
                    _logger.Debug($"resourceParamName:{this._resourceParamName},resourceIdPath:{this._resourceIdPath}");
                    if (context.ActionArguments.Keys.Contains(_resourceParamName))
                    {
                        object outObj = context.ActionArguments[_resourceParamName];
                        object tempResourceId;

                        if (string.IsNullOrEmpty(this._resourceIdPath))
                        {
                            tempResourceId = outObj;
                        }
                        else
                        {
                            tempResourceId = ValueReaderUtil.ReadValue(outObj, this._resourceIdPath);
                        }

                        if (tempResourceId != null)
                        {
                            var guids = tempResourceId as List<Guid>;
                            if (guids != null)
                            {
                                resourceIds = guids;
                            }
                            else
                            {
                                Guid tempId;
                                if (Guid.TryParse(tempResourceId.ToString(), out tempId))
                                {
                                    resourceIds.Add(tempId);
                                }
                                else
                                {
                                    _logger.Warn("can not parse param to guid");
                                }
                            }
                        }
                    }
                    else
                    {
                        throw new Exception("param not found!");
                    }
                }
            }
            catch (Exception e)
            {
                _logger.Warn($"GetResourceIds Exception {e.ToString()}", e);
                throw;
            }

            return resourceIds;
        }
    }

    public enum SubStatus
    {
        Success = 0,
        ForceSignout = 1000,
        AccountDeactivated = 2000,
    }
}
