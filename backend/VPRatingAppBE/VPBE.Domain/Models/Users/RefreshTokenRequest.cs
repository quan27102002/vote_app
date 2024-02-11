using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Models.Users
{
    public class RefreshTokenRequest
    {
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
    }
}
