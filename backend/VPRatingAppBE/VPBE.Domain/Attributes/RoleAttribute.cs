﻿using Microsoft.AspNetCore.Authentication;
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

namespace VPBE.Domain.Attributes
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = true)]
    public class RoleAttribute : Attribute, IAsyncActionFilter
    {
        private static readonly Logger _logger = LoggerHelper.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private readonly IList<UserRole> _roles;

        public RoleAttribute(UserRole[] roles)
        {
            _roles = roles ?? new UserRole[] { };
        }

        public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
        {
            if (context?.HttpContext.User.Identity != null && !context.HttpContext.User.Identity.IsAuthenticated)
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status401Unauthorized,
                    Status = StatusCodes.Status401Unauthorized,
                    Msg = ""
                });
                return;
            }
            var currentPath = context.HttpContext.Request.Path.ToString().ToLower();
            if (currentPath.Contains("/api"))
            {
                var dBRepository = context.HttpContext.RequestServices.GetRequiredService<IDBRepository>();
                var accessToken = await context.HttpContext.GetTokenAsync("access_token");
                if (!string.IsNullOrEmpty(accessToken))
                {
                    _logger.Info("Start checking token");
                    var checkExist = await dBRepository.Context.Set<TokenBlacklistEntity>().AnyAsync(a => a.AccessToken == accessToken);
                    if (checkExist)
                    {
                        context.Result = new ObjectResult(new APIResponseDto
                        {
                            Code = StatusCodes.Status401Unauthorized,
                            Status = (int)SubStatus.ForceSignout,
                            Msg = ""
                        });
                        return;
                    }
                    _logger.Info("Finish checking token");
                }
            }

            var userRole = context.HttpContext.User.FindFirstValue(ClaimTypes.Role);
            var role = (UserRole)Enum.Parse(typeof(UserRole), userRole);
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
    }

    public enum SubStatus
    {
        Success = 0,
        ForceSignout = 1000
    }
}
