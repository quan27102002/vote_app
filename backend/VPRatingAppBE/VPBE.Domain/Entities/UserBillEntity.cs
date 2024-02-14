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
        public int BillCode { get; set; }
        public string CustomerName { get; set; }
        public string CustomerCode { get; set; }
        public string Phone { get; set; }
        public DateTime StartTime { get; set; }
        public string BranchCode { get; set; }
        public string BranchAddress { get; set; }
        public string Doctor { get; set; } = string.Empty;
        public string Service { get; set; } // serialize List<Service>
        public bool IsDeleted { get; set; }
    }

    public class BranchService
    {
        public string Name { get; set; }
        public int Amount { get; set; }
        public int UnitPrice { get; set; }
    }

    public class UserRating
    {
        public Guid Id { get; set; }
        public SatisfactionLevel Level { get; set; }
        public CommentType CommentType { get; set; }
        public List<UserComment> Comments { get; set; } = new();
        public string OtherComment { get; set; } = string.Empty;
    }

    public class UserComment
    {
        public Guid Id { get; set; }
        public string Content { get; set; }
    }
}
