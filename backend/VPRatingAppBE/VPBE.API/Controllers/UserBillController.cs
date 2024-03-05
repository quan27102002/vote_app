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
using VPBE.Domain.Interfaces;

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
                var existedBills = await _dBRepository.Context.Set<UserBillEntity>().Where(a => !a.IsDeleted && billCodes.Contains(a.BillCode)).ToListAsync();
                if (existedBills.Any())
                {
                    logger.Debug($"User bill already existed, skip creating.");
                    return Ok(new CustomResponse
                    {
                        Result = existedBills.Select(a => new CreateUserBillDto { Id = a.Id, BillCode = a.BillCode, Service = JsonConvert.DeserializeObject<List<BranchService>>(a.Service) }).ToList(),
                        Message = "Mời quý khách tiếp tục tham gia đánh giá chất lượng dịch vụ."
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
                        Service = JsonConvert.SerializeObject(item.Service),
                    };
                    listUserBill.Add(userBill);
                }

                await _dBRepository.AddRangeAsync(listUserBill);
                await _dBRepository.SaveChangesAsync();

                return Ok(new CustomResponse
                {
                    Result = request.Select(a => new CreateUserBillDto { Id = a.Id, BillCode = a.BillCode, Service = a.Service }).ToList(),
                    Message = ""
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
