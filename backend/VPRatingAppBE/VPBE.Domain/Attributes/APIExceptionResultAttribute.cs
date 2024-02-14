using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Attributes
{
    [AttributeUsage(AttributeTargets.All, AllowMultiple = false)]
    public class APIExceptionResultAttribute : ExceptionFilterAttribute
    {
        public override void OnException(ExceptionContext context)
        {
            base.OnException(context);

            if (context.Exception is UnauthorizedAccessException)
            {
                context.Result = new ObjectResult(
                    new
                    {
                        Code = StatusCodes.Status401Unauthorized,
                        ErrorMessage = "Unauthorized"
                    });
            }
            else if (context.Exception is AccessDeniedException)
            {
                context.Result = new ObjectResult(
                    new
                    {
                        Code = StatusCodes.Status403Forbidden,
                        ErrorMessage = "Forbidden"
                    });
            }
            else if (context.Exception is Error500Exception)
            {
                context.Result = new ObjectResult(
                    new
                    {
                        Code = StatusCodes.Status500InternalServerError,
                        ErrorMessage = "Internal Server Error"
                    });
            }
            else if (context.Exception is Error404Exception)
            {
                context.Result = new ObjectResult(
                    new
                    {
                        Code = StatusCodes.Status404NotFound,
                        ErrorMEssage = "Resource not found"
                    });
            }
            else
            {
                context.Result = new ObjectResult(
                    new
                    {
                        Code = StatusCodes.Status200OK,
                        Status = (int)HttpStatusCode.OK,
                        ErrorMessage = context.Exception.Message
                    });
            }
        }
    }

    public class CustomException : Exception
    {
        public CustomException() : base()
        {

        }
        public CustomException(string message) : base(message)
        {

        }
        public CustomException(string message, Exception innerException) : base(message, innerException)
        {

        }
    }

    public class AccessDeniedException : CustomException
    {
        public AccessDeniedException()
        {

        }
        public AccessDeniedException(string message) : base(message)
        {

        }
    }

    public class Error500Exception : CustomException
    {
        public Error500Exception(string message) : base(message)
        {
        }
    }

    public class Error404Exception : CustomException
    {
        public Error404Exception(string message) : base(message)
        {
        }
    }

    public class Error401Exception : CustomException
    {
        public Error401Exception(string message) : base(message)
        {
        }
    }

    public class NotExistException : CustomException
    {
        public NotExistException(string sourceName) : base($"The {sourceName} doesn't exist.")
        {
        }
    }
}
