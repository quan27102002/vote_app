using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Models.Comments
{
    public class EditCommentRequest
    {
        public SatisfactionLevel Level { get; set; }
        public List<EditCommentContent> Comments { get; set; }
    }

    public class EditCommentContent
    {
        public Guid Id { get; set; }
        public string Content { get; set; }
    }
}
