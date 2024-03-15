using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NLog;
using Swashbuckle.AspNetCore.Annotations;
using VPBE.Domain.Attributes;
using VPBE.Domain.Dtos;
using VPBE.Domain.Interfaces;
using VPBE.Service.Implementations;

namespace VPBE.API.Controllers.Base
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiExceptionResult]
    [ApiController]
    [ApiResponseResult]
    [Produces("application/json")]
    public class ApiBaseController : ControllerBase
    {
        private Logger? _logger;
        protected Logger logger => _logger ??= LogManager.GetCurrentClassLogger();
        private IAuditService? _auditService;
        protected IAuditService auditService => _auditService ??= HttpContext.RequestServices.GetRequiredService<IAuditService>();
    }
}
