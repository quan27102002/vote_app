using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class UserResourceMappingEntity
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public virtual UserEntity UserEntity { get; set; }
        public Guid BranchId { get; set; } 
    }
}
