using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class UserEntity
    {
        public Guid Id { get; set; }
        public string DisplayName { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public string Code { get; set; }
        public string Password { get; set; }
        public string BranchAddress { get; set; }
        public UserRole UserRole { get; set; }
        public string AccessToken { get; set; } = string.Empty;
        public string RefreshToken { get; set; } = string.Empty;
        public TimeSpan AccessTokenExpireTime { get; set; }
        public TimeSpan RefreshTokenExpireTime { get; set; }
        public UserStatus UserStatus { get; set; }
        public DateTime CreatedOn { get; set; }
    }

    public enum UserRole
    {
        Invalid = 0,
        Admin = 1,
        Member = 2
    }

    public enum UserStatus
    {
        Inactive = 0,
        Active = 1
    }
}
