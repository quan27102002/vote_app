using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class CommentEntity : BaseEntity
    {
        public Guid Id { get; set; }
        public string Content { get; set; }
        public SatisfactionLevel Level { get; set; }
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
}
