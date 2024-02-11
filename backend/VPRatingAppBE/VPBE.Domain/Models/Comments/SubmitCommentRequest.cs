using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Models.Comments
{
    public class SubmitCommentRequest
    {
        public Guid UserBillId { get; set; }
        public SatisfactionLevel Level { get; set; }
        public CommentType CommentType { get; set; }
        public List<UserComment> Comments { get; set; } = new();
        public string OtherComment { get; set; } = string.Empty;
    }
}
