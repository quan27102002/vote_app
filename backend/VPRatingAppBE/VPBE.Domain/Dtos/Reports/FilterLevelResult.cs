using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Dtos.Reports
{
    public class FilterLevelResult
    {
        public List<DetailUserComment> UserComments { get; set; }
        public List<DetailOtherComment> OtherComments { get; set; }

    }

    public class UserCommentResult
    {
        public string BillCode { get; set; }
        public string CustomerName { get; set; }
        public string CustomerCode { get; set; }
        public string Phone { get; set; }
        public DateTime StartTime { get; set; }
        public string BranchCode { get; set; }
        public string BranchAddress { get; set; }
        //public List<BranchService> Service { get; set; } = new List<BranchService>();
    }

    public class CommonLevelResult
    {
        public Guid Id { get; set; }
        public string Content { get; set; }
        public int Count { get; set; }
    }

    public class DetailUserComment : CommonLevelResult
    {
        public List<UserCommentResult> CreatedBy { get; set; }
    }

    public class DetailOtherComment : CommonLevelResult
    {
        public UserCommentResult CreatedBy { get; set; }
    }
}
