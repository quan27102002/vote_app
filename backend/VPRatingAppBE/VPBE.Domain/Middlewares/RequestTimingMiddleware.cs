using Microsoft.AspNetCore.Http;
using NLog;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Logging;

namespace VPBE.Domain.Middlewares
{
    public class RequestTimingMiddleware
    {
        private readonly RequestDelegate _next;
        private static readonly Logger _logger = LoggerHelper.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public RequestTimingMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            var stopWatch = Stopwatch.StartNew();
            try
            {
                await _next(context);

            }
            catch (Exception ex)
            {
                _logger.Error("An error occur while running RequestTimingMiddleware", ex);
                throw;
            }
            finally
            {
                stopWatch.Stop();
                var ms = stopWatch.ElapsedMilliseconds;
                _logger.Info($"HttpRequest {context.Request.Path} takes {ms}ms in RequestTimingMiddleware");
            }
        }
    }
}
