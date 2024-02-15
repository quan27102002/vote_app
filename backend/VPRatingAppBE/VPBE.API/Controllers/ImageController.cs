using Microsoft.AspNetCore.Mvc;
using VPBE.API.Controllers.Base;
using VPBE.Domain.Utils;
using VPBE.Service.Interfaces;

namespace VPBE.API.Controllers
{
    public class ImageController : APIBaseController
    {
        private readonly IDBRepository _dBRepository;
        private readonly IWebHostEnvironment _hostEnvironment;

        public ImageController(IDBRepository dBRepository, IWebHostEnvironment hostEnvironment)
        {
            this._dBRepository = dBRepository;
            this._hostEnvironment = hostEnvironment;
        }
        [HttpPost("bulkupload")]
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
                return Ok();
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
    }
}
