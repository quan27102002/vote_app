using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class CommentResponseEntity : BaseEntity
    {
        public Guid Id { get; set; }
        public string OtherComment { get; set; } = string.Empty;
        public SatisfactionLevel Level { get; set; }
        public CommentType CommentType { get; set; }
        public string Comments { get; set; } = string.Empty;
        public Guid UserBillId { get; set; }
        public virtual UserBillEntity UserBillEntity { get; set; }
        public bool IsDeleted { get; set; }
    }
}
