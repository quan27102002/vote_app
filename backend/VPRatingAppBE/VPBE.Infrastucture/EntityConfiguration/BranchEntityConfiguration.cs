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
    public class BranchEntityConfiguration : IEntityTypeConfiguration<BranchEntity>
    {
        public void Configure(EntityTypeBuilder<BranchEntity> builder)
        {
            builder.ToTable($"{Constants.TablePrefix}_Branch");
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Id).ValueGeneratedOnAdd();
            builder.Property(x => x.Code).HasMaxLength(128).IsRequired();
            builder.Property(x => x.Name).IsRequired();
            builder.HasData(
                new BranchEntity { Id = Guid.Parse("8b2d3a8a-fd45-4136-bb27-c606696a090f"), Name = "Cơ sở Nguyễn Du", Code = "ND" },
                new BranchEntity { Id = Guid.Parse("cb73fe75-d3d6-4cea-a0ca-6e476d9daac4"), Name = "Cơ sở Bắc Ninh", Code = "BN" },
                new BranchEntity { Id = Guid.Parse("43c783d5-8e65-44e2-bd3e-6ea73fb8666a"), Name = "Cơ sở Trần Duy Hưng", Code = "DH" },
                new BranchEntity { Id = Guid.Parse("ed5fd461-eca0-4eec-a9ab-6037e7cd2939"), Name = "Cơ sở Thái Hà", Code = "TH" },
                new BranchEntity { Id = Guid.Parse("f36cd75d-785f-4e4e-a808-43c07e4e292a"), Name = "Cơ sở Trần Đăng Ninh", Code = "DN" },
                new BranchEntity { Id = Guid.Parse("16b3d63a-007a-45b1-85ad-54104a83ed0c"), Name = "Nha Khoa Úc Châu 1", Code = "HL" },
                new BranchEntity { Id = Guid.Parse("8eedff16-0053-449c-9d07-b5cc7215b5a8"), Name = "Nha Khoa Úc Châu 2", Code = "UC" },
                new BranchEntity { Id = Guid.Parse("9f037d25-10a9-4e21-b2d6-3c60fcc9095e"), Name = "Nha Khoa Úc Châu 3", Code = "UB" },
                new BranchEntity { Id = Guid.Parse("326347a7-840c-4098-9591-5d6ccec65aa4"), Name = "Cơ sở Hà Đông", Code = "HD" }
                );
        }
    }
}
