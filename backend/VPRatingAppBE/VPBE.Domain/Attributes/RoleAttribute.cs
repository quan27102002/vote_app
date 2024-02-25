using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
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
    public class RoleAttribute : Attribute, IAuthorizationFilter
    {
        private readonly IList<UserRole> _roles;
        private readonly bool _isAdmin;

        public RoleAttribute(UserRole[] roles)
        {
            _roles = roles ?? new UserRole[] { };
        }

        public RoleAttribute(UserRole[] roles, bool isAdmin)
        {
            _roles = roles ?? new UserRole[] { };
            _isAdmin = isAdmin;
        }
        public RoleAttribute(UserRole[] roles, string resource)
        {
            
        }

        public void OnAuthorization(AuthorizationFilterContext context)
        {
            var allowAnonymous = context.ActionDescriptor.EndpointMetadata.OfType<AllowAnonymousAttribute>().Any();
            if (allowAnonymous || _isAdmin)
            {
                return;
            }
            var userRole = context.HttpContext.User.FindFirstValue(ClaimTypes.Role);
            var role = (UserRole)Enum.Parse(typeof(UserRole), userRole);
            if (_roles.Any() && !_roles.Contains(role))
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status403Forbidden,
                    Status = (int)HttpStatusCode.Forbidden,
                });
            }
        }
    }
}
