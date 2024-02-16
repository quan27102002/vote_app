using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Extensions;

namespace VPBE.Domain.Attributes
{
    public class FileValidatorAttribute : ActionFilterAttribute
    {
        private readonly string[] _allowedExtensions;
        private readonly long _maxSize;
        public FileValidatorAttribute(string[] allowedExtensions, long maxSize)
        {
            _allowedExtensions = allowedExtensions;
            _maxSize = maxSize;
        }

        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var param = context.ActionArguments.SingleOrDefault(p => p.Value is IFormFile);
            if (param.Value is not IFormFile file || file.Length == 0)
            {
                context.Result = new BadRequestObjectResult("File is null");
                return;
            }
            if (!FileValidatorExtensions.IsFileExtensionAllowed(file, _allowedExtensions))
            {
                var allowedExtensionsMessage = String.Join(", ", _allowedExtensions).Replace(".", "").ToUpper();
                context.Result = new BadRequestObjectResult("Invalid file type. " +
                    $"Please upload {allowedExtensionsMessage} file.");
                return;
            }
            if (!FileValidatorExtensions.IsFileSizeWithinLimit(file, _maxSize))
            {
                var mbSize = (double)_maxSize / 1024 / 1024;
                context.Result = new BadRequestObjectResult($"File size exceeds the maximum allowed size ({mbSize} MB).");
                return;
            }
        }
    }
}
