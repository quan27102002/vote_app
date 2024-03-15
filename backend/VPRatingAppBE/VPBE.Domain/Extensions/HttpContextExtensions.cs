using IdentityModel;
using Microsoft.AspNetCore.Http;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Audit;
using VPBE.Domain.Entities;
using VPBE.Domain.Logging;

namespace VPBE.Domain.Extensions
{
    public static class HttpContextExtensions
    {
        private static readonly Logger _logger = LoggerHelper.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static Guid CurrentUserId(this HttpContext context)
        {
            var userIdClaim = GetClaimValue(context, JwtClaimTypes.Id);
            Guid.TryParse(userIdClaim, out var userId);
            return userId;
        }

        public static UserRole CurrentUserRole(this HttpContext context)
        {
            var userRole = UserRole.Invalid;
            var userRoleValue = GetClaimValue(context, JwtClaimTypes.Role);
            if (Enum.TryParse(userRoleValue, out UserRole intValue))
            {
                userRole = intValue;
            }
            return userRole;
        }
        private static String GetClaimValue(HttpContext context, String claimType)
        {
            var claimValue = context.User?.Claims?.FirstOrDefault(s => s.Type.Equals(claimType))?.Value;
            if (claimValue == null)
            {
                claimValue = string.Empty;
            }
            return claimValue;
        }

        public static string CurrentUserName(this HttpContext context)
        {
            return GetClaimValue(context, JwtClaimTypes.Name);
        }

        public static string CurrentUserDisplayName(this HttpContext context)
        {
            return GetClaimValue(context, JwtClaimTypes.PreferredUserName);
        }

        public static void AddAudit(this HttpContext context, string key, AuditModel model)
        {
            if (context.Items.ContainsKey(key))
            {
                context.Items.Remove(key);
            }
            context.Items[key] = model;
        }
    }
}
