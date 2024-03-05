using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sentry.Contracts.Middlewares
{
    public class SecureHeaderMiddleware
    {
        private readonly RequestDelegate _next;

        public SecureHeaderMiddleware(RequestDelegate next)
        {
            this._next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            context.Response.Headers.Add("X-Frame-Options", "DENY");
            context.Response.Headers.Add("X-Content-Type-Options", "nosniff");
            context.Response.Headers.Add("X-Xss-Protection", "1; mode=block");
            context.Response.Headers.Add("Referer-Policy", "no-referer");
            context.Response.Headers.Add("Content-Security-Policy", "default-src 'self';");
            await _next(context);
        }
    }
}
