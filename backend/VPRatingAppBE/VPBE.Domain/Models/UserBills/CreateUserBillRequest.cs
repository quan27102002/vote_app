using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Models.UserBills
{
    public class CreateUserBillRequest
    {
        public Guid Id { get; set; } = Guid.Empty;
        public string BillCode { get; set; }
        public string CustomerName { get; set; }
        public string CustomerCode { get; set; }
        public string Phone { get; set; }
        public DateTime StartTime { get; set; }
        public string BranchCode { get; set; }
        public string BranchAddress { get; set; }
        public string Doctor { get; set; } = string.Empty;
        public List<BranchService> Service { get; set; }
    }
}
