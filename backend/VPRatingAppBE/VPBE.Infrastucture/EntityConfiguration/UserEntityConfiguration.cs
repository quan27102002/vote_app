using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain;
using VPBE.Domain.Entities;
using VPBE.Domain.Utils;

namespace VPBE.Infrastucture.EntityConfiguration
{
    public class UserEntityConfiguration : IEntityTypeConfiguration<UserEntity>
    {
        public void Configure(EntityTypeBuilder<UserEntity> builder)
        {
            builder.ToTable($"{Constants.TablePrefix}_User");
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Id).ValueGeneratedOnAdd();
            builder.Property(x => x.DisplayName).HasMaxLength(128).IsRequired();
            builder.Property(x => x.Email).HasMaxLength(128);
            builder.Property(x => x.UserName).HasMaxLength(128).IsRequired();
            builder.Property(x => x.Code).HasMaxLength(128);
            builder.Property(x => x.Password).IsRequired();
            builder.Property(x => x.PasswordSalt).HasDefaultValue(Array.Empty<byte>()).IsRequired();
            builder.Property(x => x.BranchAddress).IsRequired();
            builder.Property(x => x.UserRole).IsRequired();
            builder.Property(x => x.AccessToken);
            builder.Property(x => x.RefreshToken);
            builder.Property(x => x.AccessTokenExpireTime);
            builder.Property(x => x.RefreshTokenExpireTime);
            builder.Property(x => x.UserStatus).IsRequired().HasDefaultValue(UserStatus.Active);
            builder.Property(x => x.CreatedOn).IsRequired();
            builder.HasData(
                new UserEntity
                {
                    Id = Constants.BuildInUserId,
                    DisplayName = "ADMIN",
                    UserName = "vietphapadmin",
                    Email = "",
                    Code = "",
                    BranchAddress = "",
                    Password = PasswordUtils.HashPassword("IKQYTX2u$BGv", out var salt),
                    PasswordSalt = salt,
                    UserRole = UserRole.Admin,
                    CreatedOn = DateTime.Now,
                },
                new UserEntity
                {
                    Id = Constants.SuperUserId,
                    DisplayName = "Super User",
                    UserName = "logsuperuser",
                    Email = "",
                    Code = "",
                    BranchAddress = "",
                    Password = PasswordUtils.HashPassword("s5qYkVXE3gus", out var SUSalt),
                    PasswordSalt = SUSalt,
                    UserRole = UserRole.SuperUser,
                    CreatedOn = DateTime.Now,
                });
        }
    }
}
