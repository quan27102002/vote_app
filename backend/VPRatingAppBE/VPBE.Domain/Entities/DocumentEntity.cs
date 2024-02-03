using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Domain.Entities
{
    public class DocumentEntity : BaseEntity
    {
        public Guid Id { get; set; }
        public byte[] Content { get; set; }
        public long Size { get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public string MimeType { get; set; }
        public Guid DocumentRuleEntityId { get; set; }
        public DocumentRuleEntity DocumentRuleEntity { get; set; }
    }
}
