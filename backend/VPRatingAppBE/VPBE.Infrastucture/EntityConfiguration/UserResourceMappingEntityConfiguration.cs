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
    public class UserResourceMappingEntityConfiguration : IEntityTypeConfiguration<UserResourceMappingEntity>
    {
        public void Configure(EntityTypeBuilder<UserResourceMappingEntity> builder)
        {
            builder.ToTable($"{Constants.TablePrefix}_UserResourceMapping");
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Id).ValueGeneratedOnAdd();
            builder.Property(a => a.UserId).IsRequired();
            builder.HasOne(a => a.UserEntity).WithOne().HasForeignKey<UserResourceMappingEntity>(a => a.UserId).OnDelete(DeleteBehavior.Cascade);
            builder.Property(a => a.BranchId).IsRequired();
        }
    }
}
