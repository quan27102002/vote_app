using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Models.Users
{
    public class RegisterUserRequest
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public UserRole Role { get; set; }
        public string DisplayName { get; set; }
        public string Email { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
        public string BranchAddress { get; set; } = string.Empty;
    }
}
