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
        public UserRole Role { get; set; }
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
    }
}
