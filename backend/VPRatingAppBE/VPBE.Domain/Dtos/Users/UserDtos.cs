using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Dtos.Users
{
    public class UserDtos
    {
        public string DisplayName { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public string Code { get; set; }
        public string BranchAddress { get; set; }
        public string UserRole { get; set; }
        public string UserStatus { get; set; }
        public DateTime CreatedOn { get; set; }
    }
}
