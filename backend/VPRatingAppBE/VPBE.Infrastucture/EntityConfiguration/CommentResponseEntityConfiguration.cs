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
    public class CommentResponseEntityConfiguration : IEntityTypeConfiguration<CommentResponseEntity>
    {
        public void Configure(EntityTypeBuilder<CommentResponseEntity> builder)
        {
            builder.ToTable($"{Constants.TablePrefix}_CommentResponse");
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Id).ValueGeneratedOnAdd();
            builder.Property(x => x.OtherComment);
            builder.Property(x => x.Level).IsRequired();
            builder.Property(x => x.CommentType).IsRequired();
            builder.Property(x => x.Comments);
            builder.Property(x => x.UserBillId).IsRequired();
            builder.HasOne(x => x.UserBillEntity).WithOne().HasForeignKey<CommentResponseEntity>(a => a.UserBillId).OnDelete(DeleteBehavior.Cascade);
            builder.Property(x => x.IsDeleted).IsRequired();
            builder.BuildBaseEntity();
        }
    }
}
