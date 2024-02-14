using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Domain.Dtos.Comments
{
    public class CommentResponseDto
    {
        public Guid Id { get; set; }
        public SatisfactionLevel Level { get; set; }
        public CommentType CommentType { get; set; }
        public List<UserComment> Comments { get; set; }
        public string OtherComment { get; set; }
    }
}
