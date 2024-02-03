using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class UserBillEntity : BaseEntity
    {
        public Guid Id { get; set; }
        public string BillCode { get; set; }
        public string CustomerName { get; set; }
        public string CustomerCode { get; set; }
        public string Phone { get; set; }
        public DateTime StartTime { get; set; }
        public string BranchCode { get; set; }
        public string BranchAddress { get; set; }
        public string Doctor { get; set; } = string.Empty;
        public string Service { get; set; }
        public int Amount { get; set; }
        public int UnitPrice { get; set; }
        public string Rate { get; set; }
        public bool IsDeleted { get; set; }
    }

    public class UserRating
    {
        public SatisfactionLevel Level { get; set; }
        public List<string> Comments { get; set; }
    }
}
