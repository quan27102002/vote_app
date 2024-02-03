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
    public class CommentEntityConfiguration : IEntityTypeConfiguration<CommentEntity>
    {
        public void Configure(EntityTypeBuilder<CommentEntity> builder)
        {
            builder.ToTable($"{Constants.TablePrefix}_Comment");
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Id).ValueGeneratedOnAdd();
            builder.Property(x => x.Content).IsRequired();
            builder.Property(x => x.Level).IsRequired();
            builder.Property(x => x.IsDeleted).IsRequired();
            builder.BuildBaseEntity();
        }
    }
}
