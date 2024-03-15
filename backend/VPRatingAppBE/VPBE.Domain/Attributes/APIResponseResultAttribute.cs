using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Dtos;
using VPBE.Domain.Logging;

namespace VPBE.Domain.Attributes
{
    public class ApiResponseResultAttribute : ActionFilterAttribute
    {
        public override void OnResultExecuting(ResultExecutingContext context)
        {
            if (context.Result is ObjectResult)
            {
                GetObjectResult(context);
            }
            else if (context.Result is EmptyResult)
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status404NotFound,
                    Status = (int)HttpStatusCode.NotFound,
                });
            }
            else if (context.Result is ContentResult)
            {
                context.Result = new ObjectResult(new APIResponseDto<object>
                {
                    Code = StatusCodes.Status200OK,
                    Status = (int)HttpStatusCode.OK,
                    Data = (context.Result as ContentResult).Content
                });
            }
            else if (context.Result is StatusCodeResult)
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = (context.Result as StatusCodeResult).StatusCode,
                    Status = (context.Result as StatusCodeResult).StatusCode,
                });
            }
            else if (context.Result is JsonResult)
            {
            }
            else
            {
                var resultObj = context.Result as ObjectResult;
                context.Result = new ObjectResult(new APIResponseDto<object>
                {
                    Code = resultObj.StatusCode.HasValue ? resultObj.StatusCode.Value : StatusCodes.Status200OK,
                    Status = (int)HttpStatusCode.OK,
                    Data = resultObj.Value
                });
            }
        }

        public static void GetObjectResult(ResultExecutingContext context)
        {
            if (context.Result is OkObjectResult)
            {
                context.Result = new ObjectResult(new APIResponseDto<object>
                {
                    Code = StatusCodes.Status200OK,
                    Status = (int)HttpStatusCode.OK,
                    Data = ((context.Result as ObjectResult).Value as CustomResponse).Result,
                    Msg = ((context.Result as ObjectResult).Value as CustomResponse).Message,
                });
            }
            else if (context.Result is BadRequestObjectResult)
            {
                context.Result = new ObjectResult(new APIResponseDto<object>
                {
                    Code = StatusCodes.Status400BadRequest,
                    Status = (int)HttpStatusCode.BadRequest,
                });
            }
            else if (context.Result is UnauthorizedResult)
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status401Unauthorized,
                    Status = (int)HttpStatusCode.Unauthorized,
                });
            }
            else if (context.Result is ForbidResult)
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status403Forbidden,
                    Status = (int)HttpStatusCode.Forbidden,
                });
            }
            else if (context.Result is NotFoundObjectResult || context.Result is NotFoundResult)
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status404NotFound,
                    Status = (int)HttpStatusCode.NotFound,
                });
            }
            else if (context.Result is CreatedAtActionResult || context.Result is CreatedAtRouteResult || context.Result is CreatedResult)
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status201Created,
                    Status = (int)HttpStatusCode.Created
                });
            }
            else if (context.Result is AcceptedAtActionResult || context.Result is AcceptedAtRouteResult || context.Result is AcceptedResult)
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status202Accepted,
                    Status = (int)HttpStatusCode.Accepted
                });
            }
            else if (context.Result is ConflictObjectResult)
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status409Conflict,
                    Status = (int)HttpStatusCode.Conflict
                });
            }
            else if (context.Result is UnprocessableEntityObjectResult)
            {
                context.Result = new ObjectResult(new APIResponseDto
                {
                    Code = StatusCodes.Status422UnprocessableEntity,
                    Status = (int)HttpStatusCode.UnprocessableEntity
                });
            }
            else
            {
                var objR = context.Result as ObjectResult;
                if (objR == null)
                {
                    throw new CustomException("Internal server error");
                }
                context.Result = new ObjectResult(objR.Value);
            }
        }
    }

    public class CustomResponse
    {
        public object? Result { get; set; }
        public string Message { get; set; } = string.Empty;
    }
}
