using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Entities;

namespace VPBE.Infrastucture.EntityConfiguration
{
    public static class BaseEntityConfigurationExtension
    {
        public static void BuildBaseEntity<T>(this EntityTypeBuilder<T> builder) where T : BaseEntity
        {
            builder.Property(a => a.CreatedById).IsRequired();
            builder.HasOne(a => a.CreatedBy).WithMany().HasForeignKey(a => a.CreatedById).OnDelete(DeleteBehavior.Restrict);
            builder.Property(a => a.CreatedTime).IsRequired();
            builder.Property(a => a.ModifiedById).IsRequired();
            builder.HasOne(a => a.ModifiedBy).WithMany().HasForeignKey(a => a.ModifiedById).OnDelete(DeleteBehavior.Restrict);
            builder.Property(a => a.ModifiedTime).IsRequired();
        }
    }
}
