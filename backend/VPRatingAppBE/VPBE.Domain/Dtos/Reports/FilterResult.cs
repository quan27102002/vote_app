using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Dtos.Reports
{
    public class FilterResult
    {
        public SatisfactionLevel Level { get; set; }
        public int Count { get; set; }
        public string Description { get; set; }
    }
}
