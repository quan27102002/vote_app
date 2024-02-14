using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class CommentEntity
    {
        public Guid Id { get; set; }
        public string Content { get; set; } = string.Empty;
        public SatisfactionLevel Level { get; set; }
        public CommentType CommentType { get; set; }
        public bool IsDeleted { get; set; }
    }

    public enum SatisfactionLevel
    {
        VeryBad = 0,
        Bad,
        Acceptable,
        Good,
        Perfect
    }

    public enum CommentType
    {
        BuiltIn = 0,
        Customized = 1,
        Mixed = 2
    }
}
