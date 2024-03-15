﻿using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using VPBE.API.Controllers.Base;
using VPBE.Domain.Attributes;
using VPBE.Domain.Dtos;
using VPBE.Domain.Entities;
using VPBE.Domain.Utils;
using VPBE.Domain.Interfaces;
using VPBE.Domain.Audit;

namespace VPBE.API.Controllers
{
    public class ImageController : ApiBaseController
    {
        private readonly IWebHostEnvironment _hostEnvironment;

        public ImageController(IWebHostEnvironment hostEnvironment)
        {
            this._hostEnvironment = hostEnvironment;
        }
        [HttpPost("bulkupload")]
        [Permission(new UserRole[] { UserRole.Admin })]
        [FileValidator(new string[] {".png", ".jpg"}, 5 * 1024 * 1024)]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<bool>))]
        public async Task<IActionResult> BulkUpload(IFormFileCollection formFiles)
        {
            int successCount = 0;
            try
            {
                string path = GetImagePath();
                if (!Directory.Exists(path))
                {
                    logger.Debug($"Create directory {path}");
                    Directory.CreateDirectory(path);
                }
                DirectoryInfo directoryInfo = new DirectoryInfo(path);
                FileInfo[] fileInfos = directoryInfo.GetFiles();
                foreach (FileInfo fileInfo in fileInfos)
                {
                    fileInfo.Delete();
                }
                foreach (var item in formFiles)
                {
                    string imagePath = $"{path}\\{DateTimeUtils.GetTimestamp(DateTime.Now)}_{item.FileName}";
                    if (System.IO.File.Exists(imagePath))
                    {
                        System.IO.File.Delete(imagePath);
                    }
                    using (FileStream stream = System.IO.File.Create(imagePath))
                    {
                        await item.CopyToAsync(stream);
                        successCount++;
                    }
                }
                auditService.AddAudit(AuditAction.BulkUpload);
                return Ok(new CustomResponse
                {
                    Result = true,
                    Message = $"{successCount}/{formFiles.Count} files đã tải lên thành công."
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error bulk uploading. Message: {ex.Message}", ex);
                throw;
            }
        }
        [NonAction]
        private string GetImagePath()
        {
            return _hostEnvironment.WebRootPath + "\\assets\\images";
        }

        [HttpGet("get")]
        [Permission(new UserRole[] { UserRole.Admin, UserRole.Member, UserRole.Guest })]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<List<string>>))]
        public async Task<IActionResult> GetImages()
        {
            var host = $"{Request.Scheme}://{Request.Host}{Request.PathBase}";
            var imageUrls = new List<string>();
            try
            {
                var path = GetImagePath();
                if (Directory.Exists(path))
                {
                    DirectoryInfo directoryInfo = new DirectoryInfo(path);
                    FileInfo[] fileInfos = directoryInfo.GetFiles();
                    var listFileName = fileInfos.Select(a => a.Name);
                    foreach (var item in listFileName)
                    {
                        string imagepath = path + "\\" + item;
                        if (System.IO.File.Exists(imagepath))
                        {
                            string url = host + "/assets/images/" + item.Replace(" ", "%20");
                            imageUrls.Add(url);
                        }
                    }
                }
                auditService.AddAudit(AuditAction.ViewImages);
                return Ok(new CustomResponse
                {
                    Result = imageUrls,
                    Message = ""
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error getting images. Message: {ex.Message}", ex);
                throw;
            }
        }
    }
}
