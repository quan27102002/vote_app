using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain;
using VPBE.Domain.Entities;

namespace VPBE.Infrastucture.EntityConfiguration
{
    public class DocumentEntityConfiguration : IEntityTypeConfiguration<DocumentEntity>
    {
        public void Configure(EntityTypeBuilder<DocumentEntity> builder)
        {
            builder.ToTable($"{Constants.TablePrefix}_Document");
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Id).ValueGeneratedOnAdd();
            builder.Property(x => x.Content).IsRequired();
            builder.Property(x => x.Size).IsRequired();
            builder.Property(x => x.FileName).IsRequired();
            builder.Property(x => x.FileType).IsRequired();
            builder.Property(x => x.MimeType).IsRequired();
            builder.Property(x => x.DocumentRuleEntityId).IsRequired();
            builder.HasOne(x => x.DocumentRuleEntity).WithMany(x => x.DocumentEntities).HasForeignKey(x => x.DocumentRuleEntityId).OnDelete(DeleteBehavior.Restrict);
            builder.BuildBaseEntity();
        }
    }
}
