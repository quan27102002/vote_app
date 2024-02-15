using Microsoft.AspNetCore.Mvc;
using VPBE.API.Controllers.Base;
using VPBE.Service.Interfaces;

namespace VPBE.API.Controllers
{
    public class ImageController : APIBaseController
    {
        private readonly IDBRepository _dBRepository;

        public ImageController(IDBRepository dBRepository)
        {
            this._dBRepository = dBRepository;
        }
        [HttpPost("bulkupload")]
        public async Task<IActionResult> BulkUpload(IFormFileCollection formFiles)
        {
            try
            {
                return Ok();
            }
            catch (Exception ex)
            {
                logger.Error($"Error bulk uploading. Message: {ex.Message}", ex);
                throw;
            }
        }
    }
}
