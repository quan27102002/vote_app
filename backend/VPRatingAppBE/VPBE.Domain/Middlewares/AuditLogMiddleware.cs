using Microsoft.AspNetCore.Http;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using VPBE.Domain.Audit;
using VPBE.Domain.Entities;
using VPBE.Domain.Extensions;
using VPBE.Domain.Interfaces;

namespace VPBE.Domain.Middlewares
{
    public class AuditLogMiddleware
    {
        private const string ControllerKey = "controller";
        private const string IdKey = "id";
        private readonly RequestDelegate _next;
        public AuditLogMiddleware(RequestDelegate next)
        {
            _next = next;
        }
        public async Task InvokeAsync(HttpContext context, IDBRepository dBRepository)
        {
            await _next(context);
            var request = context.Request;
            if (request.Path.StartsWithSegments("/api"))
            {
                request.RouteValues.TryGetValue(ControllerKey, out var controllerValue);
                var controllerName = (string)(controllerValue ?? string.Empty);
                var changedValue = await GetChangedValues(request).ConfigureAwait(false);
                if (context.Items.ContainsKey("AuditObjKey"))
                {
                    var auditLog = new AuditLogEntity
                    {
                        Username = context.CurrentUserDisplayName(),
                        IpAddress = context.Connection.RemoteIpAddress.ToString(),
                        EntityName = controllerName,
                        Description = (context.Items["AuditObjKey"] as AuditModel).Description.ToDescription(),
                        Action = request.Method,
                        Timestamp = DateTime.Now,
                        ObjectInfo = changedValue
                    };
                    await dBRepository.AddAsync(auditLog);
                    await dBRepository.SaveChangesAsync();
                }
            }
        }

        private static async Task<string> GetChangedValues(HttpRequest request)
        {
            var changedValue = string.Empty;
            switch (request.Method)
            {
                case "POST":
                case "PUT":
                    changedValue = await ReadRequestBody(request, Encoding.UTF8).ConfigureAwait(false);
                    break;
                case "DELETE":
                    request.RouteValues.TryGetValue(IdKey, out var idValueObj);
                    changedValue = (string?)idValueObj ?? string.Empty;
                    break;
                default:
                    break;
            }
            return changedValue;
        }
        private static async Task<string> ReadRequestBody(HttpRequest request, Encoding? encoding = null)
        {
            request.Body.Position = 0;
            if (request.Path.HasValue && request.Path.Value.Contains("/api/Image/bulkupload"))
            {
                var result = string.Join("; ",request.Form.Files.Select(a => a.FileName).ToList());
                request.Body.Position = 0;
                return result;
            }
            var reader = new StreamReader(request.Body, encoding ?? Encoding.UTF8);
            var requestBody = await reader.ReadToEndAsync().ConfigureAwait(false);
            if (request.Path.HasValue && request.Path.Value.Contains("/api/User/login"))
            {
                JObject json = JObject.Parse(requestBody);
                json["password"] = "************";
                string result = json.ToString();
                request.Body.Position = 0;
                return result;
            }
            request.Body.Position = 0;
            return requestBody;
        }
    }
}
