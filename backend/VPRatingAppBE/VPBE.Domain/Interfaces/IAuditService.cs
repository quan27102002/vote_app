using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Audit;

namespace VPBE.Domain.Interfaces
{
    public interface IAuditService
    {
        void AddAudit(AuditAction action);
    }
}
