using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class DocumentRuleEntity : BaseEntity
    {
        public Guid Id { get; set; }
        public string FolderPath { get; set; }
        public Guid RegardingId { get; set; } //reference to where the file is uploaded
        public ICollection<DocumentEntity> DocumentEntities { get; set; }
    }
}
