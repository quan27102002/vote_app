using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class AuditLogEntity
    {
        public Guid Id { get; set; }
        public string Username { get; set; }
        public string IpAddress { get; set; }
        public string Description { get; set; }
        public string EntityName { get; set; }
        public string Action { get; set; }
        public DateTime Timestamp { get; set; }
        public string ObjectInfo { get; set; }
    }
}
