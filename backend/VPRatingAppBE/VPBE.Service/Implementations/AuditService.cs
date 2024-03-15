using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Audit;
using VPBE.Domain.Extensions;
using VPBE.Domain.Interfaces;

namespace VPBE.Service.Implementations
{
    public class AuditService : IAuditService
    {
        private readonly IHttpContextAccessor _context;

        public AuditService(IHttpContextAccessor context)
        {
            _context = context;
        }
        public void AddAudit(AuditAction action)
        {
            _context.HttpContext.AddAudit("AuditObjKey", new AuditModel { Description = action });
        }
    }
}
