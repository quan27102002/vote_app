using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Models.Reports
{
    public class FilterModel
    {
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public string BranchCode { get; set; } = string.Empty;
    }
}
