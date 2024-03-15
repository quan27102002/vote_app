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
    public class AuditLogEntityConfiguration : IEntityTypeConfiguration<AuditLogEntity>
    {
        public void Configure(EntityTypeBuilder<AuditLogEntity> builder)
        {
            builder.ToTable($"{Constants.TablePrefix}_Audit");
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Id).ValueGeneratedOnAdd();
            builder.Property(x => x.Username).IsRequired();
            builder.Property(x => x.IpAddress).IsRequired();
            builder.Property(x => x.Description).IsRequired();
            builder.Property(x => x.EntityName).IsRequired();
            builder.Property(x => x.Action).IsRequired();
            builder.Property(x => x.Timestamp).IsRequired();
            builder.Property(x => x.ObjectInfo).IsRequired();
        }
    }
}
