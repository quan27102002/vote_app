using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NLog;
using Swashbuckle.AspNetCore.Annotations;
using VPBE.Domain.Attributes;
using VPBE.Domain.Dtos;

namespace VPBE.API.Controllers.Base
{
    [Authorize]
    [Route("api/[controller]")]
    [APIExceptionResult]
    [ApiController]
    [APIResponseResult]
    [Produces("application/json")]
    public class APIBaseController : ControllerBase
    {
        private Logger? _logger;
        protected Logger logger => _logger ??= LogManager.GetCurrentClassLogger();
    }
}
