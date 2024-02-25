using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Dtos;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Attributes
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = true)]
    public class RoleAttribute : Attribute, IAsyncActionFilter
    {
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
                    Status = (int)HttpStatusCode.Unauthorized,
                });
                return;
            }
            //var currentPath = context.HttpContext.Request.Path.ToString().ToLower();
            //if (currentPath.Contains("/api"))
            //{
            //    var accessToken = await context.HttpContext.GetTokenAsync("access_token");

            //}

            var userRole = context.HttpContext.User.FindFirstValue(ClaimTypes.Role);
            var role = (UserRole)Enum.Parse(typeof(UserRole), userRole);
            if (_roles.Any() && !_roles.Contains(role))
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status403Forbidden,
                    Status = (int)HttpStatusCode.Forbidden,
                });
                return;
            }

            await next();
        }
    }
}
