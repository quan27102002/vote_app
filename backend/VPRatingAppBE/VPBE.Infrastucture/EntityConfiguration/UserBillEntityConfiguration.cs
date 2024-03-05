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
    public class UserBillEntityConfiguration : IEntityTypeConfiguration<UserBillEntity>
    {
        public void Configure(EntityTypeBuilder<UserBillEntity> builder)
        {
            builder.ToTable($"{Constants.TablePrefix}_UserBill");
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Id).ValueGeneratedOnAdd();
            builder.Property(x => x.BillCode).IsRequired();
            builder.Property(x => x.CustomerName).IsRequired();
            builder.Property(x => x.CustomerCode).IsRequired();
            builder.Property(x => x.Phone).IsRequired();
            builder.Property(x => x.StartTime).IsRequired();
            builder.Property(x => x.BranchCode).IsRequired();
            builder.Property(x => x.BranchAddress).IsRequired();
            builder.Property(x => x.Service).IsRequired();
            builder.Property(x => x.IsDeleted).IsRequired();
            builder.BuildBaseEntity();
        }
    }
}
