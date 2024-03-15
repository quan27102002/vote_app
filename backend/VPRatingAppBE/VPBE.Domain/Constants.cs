using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain
{
    public class Constants
    {
        public const string DevEnv = "Development";
        public const string ASPNETCORE_ENVIRONMENT = "ASPNETCORE_ENVIRONMENT";

        public const string TablePrefix = "VP";

        public static readonly Guid BuildInUserId = new Guid("0b44ccde-4a10-4088-a76c-99b4c739455d");
        public static readonly Guid SuperUserId = new Guid("c86d9bc1-7d17-4008-a5ab-ba5e5c9810c2");
    }
}
