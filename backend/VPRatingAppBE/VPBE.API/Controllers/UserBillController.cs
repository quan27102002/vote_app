using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Swashbuckle.AspNetCore.Annotations;
using VPBE.API.Controllers.Base;
using VPBE.Domain.Attributes;
using VPBE.Domain.Dtos;
using VPBE.Domain.Dtos.UserBills;
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
        [SwaggerResponse(200, Type = typeof(APIResponseDto<List<CreateUserBillDto>>))]
        public async Task<IActionResult> CreateUserBill([FromBody] List<CreateUserBillRequest> request)
        {
            try
            {
                logger.Debug("Start creating user bill");
                var billCodes = request.Select(a => a.BillCode).ToList();
                var isExisted = await _dBRepository.Context.Set<UserBillEntity>().AnyAsync(a => !a.IsDeleted && billCodes.Contains(a.BillCode));
                if (isExisted)
                {
                    logger.Error("User bill already existed");
                    return Ok(new CustomResponse
                    {
                        Result = false,
                        Message = "User bill already existed"
                    });
                }
                var listUserBill = new List<UserBillEntity>();
                foreach (var item in request)
                {
                    item.Id = Guid.NewGuid();
                    var userBill = new UserBillEntity
                    {
                        Id = item.Id,
                        BillCode = item.BillCode,
                        CustomerCode = item.CustomerCode,
                        CustomerName = item.CustomerName,
                        Phone = item.Phone,
                        StartTime = item.StartTime,
                        BranchCode = item.BranchCode,
                        BranchAddress = item.BranchAddress,
                        Doctor = item.Doctor,
                        Service = JsonConvert.SerializeObject(item.Service),
                    };
                    listUserBill.Add(userBill);
                }

                await _dBRepository.AddRangeAsync(listUserBill);
                await _dBRepository.SaveChangesAsync();

                return Ok(new CustomResponse
                {
                    Result = request.Select(a => new CreateUserBillDto { Id = a.Id, BillCode = a.BillCode, Doctor = a.Doctor, Service = a.Service }).ToList(),
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
