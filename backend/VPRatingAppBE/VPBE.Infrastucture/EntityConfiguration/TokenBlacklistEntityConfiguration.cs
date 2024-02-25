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
    public class TokenBlacklistEntityConfiguration : IEntityTypeConfiguration<TokenBlacklistEntity>
    {
        public void Configure(EntityTypeBuilder<TokenBlacklistEntity> builder)
        {
            builder.ToTable($"{Constants.TablePrefix}_TokenBlacklist");
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Id).ValueGeneratedOnAdd();
            builder.Property(x => x.AccessToken).IsRequired();
            builder.Property(x => x.RefreshToken).IsRequired();
            builder.Property(x => x.CreatedOn).IsRequired();
        }
    }
}
