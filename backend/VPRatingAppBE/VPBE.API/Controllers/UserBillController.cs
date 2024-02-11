using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Swashbuckle.AspNetCore.Annotations;
using VPBE.API.Controllers.Base;
using VPBE.Domain.Attributes;
using VPBE.Domain.Dtos;
using VPBE.Domain.Entities;
using VPBE.Domain.Models.UserBills;
using VPBE.Service.Interfaces;

namespace VPBE.API.Controllers
{
    public class UserBillController : APIBaseController
    {
        private readonly IDBRepository _dBRepository;

        public UserBillController(IDBRepository dBRepository)
        {
            this._dBRepository = dBRepository;
        }

        [HttpPost("create")]
        [SwaggerResponse(200, Type = typeof(APIResponseDto<bool>))]
        public async Task<IActionResult> CreateUserBill([FromBody] CreateUserBillRequest request)
        {
            try
            {
                logger.Debug("Start creating user bill");
                var isExisted = await _dBRepository.Context.Set<UserBillEntity>().AnyAsync(a => !a.IsDeleted && a.BillCode == request.BillCode);
                if (isExisted)
                {
                    logger.Error("User bill already existed");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "User bill already existed"
                    });
                }
                var userBill = new UserBillEntity
                {
                    BillCode = request.BillCode,
                    CustomerCode = request.CustomerCode,
                    CustomerName = request.CustomerName,
                    Phone = request.Phone,
                    StartTime = request.StartTime,
                    BranchCode = request.BranchCode,
                    BranchAddress = request.BranchAddress,
                    Doctor = request.Doctor,
                    Service = JsonConvert.SerializeObject(request.Service),
                };

                await _dBRepository.AddAsync(userBill);
                await _dBRepository.SaveChangesAsync();

                return Ok(new CustomResponse
                {
                    Result = true,
                    Message = "Success"
                });
            }
            catch (Exception ex)
            {
                logger.Error($"Error create user bill. Message: {ex.Message}", ex);
                throw;
            }
        }
    }

}
