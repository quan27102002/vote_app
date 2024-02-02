using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain.Logging;

namespace VPBE.Infrastucture.Core
{
    public class VPDbContext : DbContext
    {
        public VPDbContext(DbContextOptions<VPDbContext> options) : base(options)
        {
            
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            CommonModelBuilder.AppendConfiguration(modelBuilder);
        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseLoggerFactory(LoggerHelper.GetLoggerFactory());
            base.OnConfiguring(optionsBuilder);
        }
    }
}
