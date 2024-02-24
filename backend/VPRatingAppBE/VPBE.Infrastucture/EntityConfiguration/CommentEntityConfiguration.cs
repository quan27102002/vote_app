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
            builder.Property(x => x.CommentType).IsRequired();
            builder.Property(x => x.IsDeleted).IsRequired();
            builder.HasData(
                new CommentEntity { Id = new Guid("53DA7D20-7085-47D5-B6D5-42432CA09603"), Content = "Bảo vệ/nhân viên phòng khám thiếu nhiệt tình", Level = SatisfactionLevel.VeryBad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("44661AEE-76D8-4526-8145-9395C46F5C8E"), Content = "Nhân viên phòng khám thái độ chưa tốt, tư vấn không đúng với nhu cầu", Level = SatisfactionLevel.VeryBad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("71F72DFE-9B15-43FC-9BB2-5A64088E454E"), Content = "Không gian phòng khám cũ, kém tiện nghi", Level = SatisfactionLevel.VeryBad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("31e87f3e-8cb4-4744-a889-1982e233fca0"), Content = "Y bác sĩ khám điều trị rất yếu kém, chăm sóc sau điều trị rất kém", Level = SatisfactionLevel.VeryBad, CommentType = CommentType.BuiltIn },

                new CommentEntity { Id = new Guid("52D4DA7B-6FE5-45D1-B57D-DAEE36092DFD"), Content = "Bảo vệ/nhân viên phòng khám thiếu nhiệt tình", Level = SatisfactionLevel.Bad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("BFD9893D-6D51-41FE-A071-F829970E30ED"), Content = "Nhân viên phòng khám thái độ chưa tốt, tư vấn không đúng với nhu cầu", Level = SatisfactionLevel.Bad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("6A74D774-2E5E-4DB4-9E85-6F3F42493575"), Content = "Không gian phòng khám cũ, kém tiện nghi", Level = SatisfactionLevel.Bad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("18950d3f-a34b-44dd-a2d8-8befc3b867b7"), Content = "Y bác sĩ khám điều trị yếu kém, chăm sóc sau điều trị kém", Level = SatisfactionLevel.Bad, CommentType = CommentType.BuiltIn },

                new CommentEntity { Id = new Guid("DAFA87AE-8A08-4D84-9822-230DA9987FD8"), Content = "Dịch vụ tạm ổn nhưng không có gì ấn tượng", Level = SatisfactionLevel.Acceptable, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("f69fb2ec-8621-4189-b8d2-911679368e1d"), Content = "Không gian đơn điệu, không có điểm nhấn", Level = SatisfactionLevel.Acceptable, CommentType = CommentType.BuiltIn },

                new CommentEntity { Id = new Guid("C3F83585-8F74-4DE5-A9C9-5A57B71A95E7"), Content = "Bảo vệ/nhân viên phòng khám nhiệt tình, niềm nở", Level = SatisfactionLevel.Good, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("03AFF69F-3235-4F8F-960D-4B5B65C4779E"), Content = "Nhân viên phòng khám thái độ tốt, tư vấn tận tâm", Level = SatisfactionLevel.Good, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("83CA1EF9-417B-439B-BE61-8D6FB0FBC9E2"), Content = "Y bác sĩ khám điều trị tốt, chăm sóc sau điều trị tốt", Level = SatisfactionLevel.Good, CommentType = CommentType.BuiltIn },

                new CommentEntity { Id = new Guid("8546BCCF-B28B-4FF0-9229-086A0E8AD34E"), Content = "Bảo vệ/nhân viên phòng khám nhiệt tình, niềm nở", Level = SatisfactionLevel.Perfect, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("20C137FD-3D1E-45A4-84F7-67B3F5E01B9D"), Content = "Nhân viên phòng khám thái độ tốt, tư vấn tận tâm", Level = SatisfactionLevel.Perfect, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("858CCD82-C04E-422F-AB0D-AB73A50BD0E4"), Content = "Y bác sĩ khám điều trị tốt, chăm sóc sau điều trị tốt", Level = SatisfactionLevel.Perfect, CommentType = CommentType.BuiltIn }
                );
        }
    }
}
