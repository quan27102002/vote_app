using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class BaseEntity
    {
        public Guid CreatedById { get; set; }
        public virtual UserEntity CreatedBy { get; set; }
        public Guid ModifiedById { get; set; }
        public virtual UserEntity ModifiedBy { get; set; }
        public DateTime CreatedTime { get; set; }
        public DateTime ModifiedTime { get; set; }
    }
}
