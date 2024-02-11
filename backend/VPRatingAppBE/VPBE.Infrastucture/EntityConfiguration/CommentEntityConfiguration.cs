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
                new CommentEntity { Id = new Guid("53DA7D20-7085-47D5-B6D5-42432CA09603"), Content = "Bảo vệ, nhân viên rất thiếu nhiệt tình", Level = SatisfactionLevel.VeryBad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("44661AEE-76D8-4526-8145-9395C46F5C8E"), Content = "Y bác sĩ khám, điều trị rất yếu kém", Level = SatisfactionLevel.VeryBad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("71F72DFE-9B15-43FC-9BB2-5A64088E454E"), Content = "Chăm sóc sau điều trị rất kém", Level = SatisfactionLevel.VeryBad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("52D4DA7B-6FE5-45D1-B57D-DAEE36092DFD"), Content = "Bảo vệ, nhân viên không nhiệt tình", Level = SatisfactionLevel.Bad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("BFD9893D-6D51-41FE-A071-F829970E30ED"), Content = "Y bác sĩ khám, điều trị yếu kém", Level = SatisfactionLevel.Bad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("6A74D774-2E5E-4DB4-9E85-6F3F42493575"), Content = "Chăm sóc sau điều trị kém", Level = SatisfactionLevel.Bad, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("DAFA87AE-8A08-4D84-9822-230DA9987FD8"), Content = "", Level = SatisfactionLevel.Acceptable, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("C3F83585-8F74-4DE5-A9C9-5A57B71A95E7"), Content = "Bảo vệ và nhân viên nhiệt tình", Level = SatisfactionLevel.Good, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("03AFF69F-3235-4F8F-960D-4B5B65C4779E"), Content = "Y bác sĩ khám, điều trị tốt", Level = SatisfactionLevel.Good, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("83CA1EF9-417B-439B-BE61-8D6FB0FBC9E2"), Content = "Chăm sóc sau điều trị tốt", Level = SatisfactionLevel.Good, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("8546BCCF-B28B-4FF0-9229-086A0E8AD34E"), Content = "Bảo vệ, nhân viên rất nhiệt tình", Level = SatisfactionLevel.Perfect, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("20C137FD-3D1E-45A4-84F7-67B3F5E01B9D"), Content = "Y bác sĩ khám, điều trị rất tốt", Level = SatisfactionLevel.Perfect, CommentType = CommentType.BuiltIn },
                new CommentEntity { Id = new Guid("858CCD82-C04E-422F-AB0D-AB73A50BD0E4"), Content = "Chăm sóc sau điều trị rất chu đáo", Level = SatisfactionLevel.Perfect, CommentType = CommentType.BuiltIn }
                );
        }
    }
}
