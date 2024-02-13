using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Models.Reports
{
    public class FilterByLevelModel : FilterModel
    {
        public SatisfactionLevel Level { get; set; }
    }
}
