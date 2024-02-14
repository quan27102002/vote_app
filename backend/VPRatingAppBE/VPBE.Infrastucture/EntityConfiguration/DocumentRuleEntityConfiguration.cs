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
    public class DocumentRuleEntityConfiguration : IEntityTypeConfiguration<DocumentRuleEntity>
    {
        public void Configure(EntityTypeBuilder<DocumentRuleEntity> builder)
        {
            builder.ToTable($"{Constants.TablePrefix}_DocumentRule");
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Id).ValueGeneratedOnAdd();
            builder.Property(x => x.FolderPath).IsRequired();
            builder.Property(x => x.RegardingId).IsRequired().HasDefaultValue(Guid.Empty);
            builder.BuildBaseEntity();
        }
    }
}
