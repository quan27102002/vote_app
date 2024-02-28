﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Dtos;
using VPBE.Domain.Extensions;
using VPBE.Domain.Logging;

namespace VPBE.Domain.Attributes
{
    [AttributeUsage(AttributeTargets.All, AllowMultiple = false)]
    public class FileValidatorAttribute : ActionFilterAttribute
    {
        private static readonly Logger _logger = LoggerHelper.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private readonly string[] _allowedExtensions;
        private readonly long _maxSize;
        public FileValidatorAttribute(string[] allowedExtensions, long maxSize)
        {
            _allowedExtensions = allowedExtensions;
            _maxSize = maxSize;
        }

        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var param = context.ActionArguments.SingleOrDefault(p => p.Value is IFormFileCollection);
            _logger.Info($"Executing upload files, param: {param}");
            if (param.Value is not IFormFileCollection files || files.Count == 0)
            {
                _logger.Error($"File is null");
                context.Result = new ObjectResult(new  APIResponseDto
                {
                    Code = StatusCodes.Status400BadRequest,
                    Status = StatusCodes.Status400BadRequest,
                    Msg = "Files tải lên không tồn tại."
                });
                return;
            }
            foreach (var file in files)
            {
                if (!FileValidatorExtensions.IsFileExtensionAllowed(file, _allowedExtensions))
                {
                    var allowedExtensionsMessage = String.Join(", ", _allowedExtensions).Replace(".", "").ToUpper();
                    _logger.Error($"Invalid file type");
                    context.Result = new ObjectResult(new APIResponseDto
                    {
                        Code = StatusCodes.Status400BadRequest,
                        Status = StatusCodes.Status400BadRequest,
                        Msg = $"Định dạng file không hợp lệ. Hãy tải lên ảnh với định dạng \"{allowedExtensionsMessage}\""
                    });
                    return;
                }
                if (!FileValidatorExtensions.IsFileSizeWithinLimit(file, _maxSize))
                {
                    var mbSize = (double)_maxSize / 1024 / 1024;
                    _logger.Error($"File size exceeds the maximum allowed size");

                    context.Result = new ObjectResult(new APIResponseDto
                    {
                        Code = StatusCodes.Status400BadRequest,
                        Status = StatusCodes.Status400BadRequest,
                        Msg = $"Dung lượng file vượt quá giới hạn ({mbSize}MB)"
                    });
                    return;
                }
            }
            _logger.Info("Finish uploading files");
        }
    }
}
