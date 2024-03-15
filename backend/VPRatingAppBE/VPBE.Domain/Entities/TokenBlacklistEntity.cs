using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class TokenBlacklistEntity
    {
        public Guid Id { get; set; }
        public string AccessToken { get; set; } = string.Empty;
        public string RefreshToken { get; set; } = string.Empty;
        public Guid IssuedById { get; set; }
        public virtual UserEntity IssuedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ExpiredAt { get; set; }
    }
}
