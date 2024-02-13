using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Dtos.Users
{
    public class UserLoginResult
    {
        public Guid UserId { get; set; }
        public string DisplayName { get; set; }
        public string BranchCode { get; set; }
        public string BranchAddress { get; set; }
        public UserRole Role { get; set; }
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
    }
}
