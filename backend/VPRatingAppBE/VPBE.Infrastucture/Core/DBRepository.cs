using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Security.AccessControl;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using VPBE.Domain;
using VPBE.Domain.Audit;
using VPBE.Domain.Entities;
using VPBE.Domain.Extensions;
using VPBE.Domain.Interfaces;

namespace VPBE.Infrastucture.Core
{
    public class DBRepository : IDBRepository
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public DbContext Context { get; }

        public DBRepository()
        {

        }

        public DBRepository(DbContext context, IHttpContextAccessor httpContextAccessor)
        {
            context.Database.SetCommandTimeout(180);
            Context = context;
            this._httpContextAccessor = httpContextAccessor;
        }

        public async Task<T> AddAsync<T>(T entity) where T : class
        {
            var entry = await Context.Set<T>().AddAsync(entity);
            return entry.Entity;
        }

        public async Task AddRangeAsync<T>(IEnumerable<T> entities) where T : class
        {
            await Context.Set<T>().AddRangeAsync(entities);
        }

        public int Delete<T>(T entity) where T : class
        {
            Context.Set<T>().Remove(entity);
            return 1;
        }

        public int Delete<T>(Expression<Func<T, bool>> predicate) where T : class
        {
            var removeList = Context.Set<T>().Where(predicate);
            Context.Set<T>().RemoveRange(removeList);
            return removeList.Count();
        }

        public async Task<int> DeleteAsync<T>(Expression<Func<T, bool>> predicate) where T : class
        {
            return await Task.Run(() => Delete(predicate), default(CancellationToken));
        }

        public int DeleteRange<T>(IEnumerable<T> entities) where T : class
        {
            Context.Set<T>().RemoveRange(entities);
            return entities.Count();
        }

        public void Dispose()
        {
        }

        public async Task<int> ExecuteSqlCommandAsync(string sql, params object[] param)
        {
            return await Context.Database.ExecuteSqlRawAsync(sql, param);
        }

        public async Task<int> ExecuteSqlCommandAsync(string formattedSql)
        {
            return await Context.Database.ExecuteSqlRawAsync(formattedSql);
        }

        public async Task<TResult> FirstOrDefaultAsync<TResult>(Expression<Func<TResult, bool>> expression, bool track = true) where TResult : class
        {
            return track
               ? await Context.Set<TResult>().FirstOrDefaultAsync(expression)
               : await Context.Set<TResult>().Where(expression).AsNoTracking().FirstOrDefaultAsync();
        }

        public IQueryable<T> FromSql<T>(string sql, params object[] param) where T : class
        {
            return Context.Set<T>().FromSqlRaw(sql, param);
        }

        public IQueryable<T> FromSql<T>(string formattedSql) where T : class
        {
            return Context.Set<T>().FromSqlRaw(formattedSql);
        }

        public async Task<int> SaveChangesAsync(AuditAction action = AuditAction.None, CancellationToken cancellationToken = default)
        {
            BeforeSaveChanges(action);
            return await Context.SaveChangesAsync(cancellationToken);
        }

        public int Update<T>(T entity) where T : class
        {
            throw new NotImplementedException();
        }

        private void BeforeSaveChanges(AuditAction action = AuditAction.None)
        {
            var dateTime = DateTime.Now;
            var entities = Context.ChangeTracker.Entries();
            foreach (var entity in entities)
            {
                if (entity.Entity is BaseEntity baseEntity)
                {
                    var currentUserId = _httpContextAccessor.HttpContext.CurrentUserId();
                    var userId = currentUserId != Guid.Empty ? currentUserId : Constants.BuildInUserId;
                    switch (entity.State)
                    {
                        case EntityState.Added:
                            baseEntity.CreatedById = userId;
                            baseEntity.ModifiedById = userId;
                            baseEntity.CreatedTime = dateTime;
                            baseEntity.ModifiedTime = dateTime;
                            break;
                        case EntityState.Modified:
                            baseEntity.ModifiedTime = dateTime;
                            break;
                    }
                }

                //var auditLog = new AuditLogEntity
                //{
                //    Username = _httpContextAccessor.HttpContext.CurrentUserName(),
                //    IpAddress = _httpContextAccessor.HttpContext.Connection.RemoteIpAddress.ToString(),
                //    Description = action.ToDescription(),
                //    EntityName = entity.Entity.GetType().Name,
                //    Action = entity.State.ToString(),
                //    Timestamp = DateTime.Now,
                //    ObjectInfo = GetChanges(entity)
                //};
                //Context.Add(auditLog);
            }
        }

        private static string GetChanges(EntityEntry entity)
        {
            var changes = new StringBuilder();
            foreach (var property in entity.OriginalValues.Properties)
            {
                var originalValue = entity.OriginalValues[property];
                var currentValue = entity.CurrentValues[property];
                if (!Equals(originalValue, currentValue))
                {
                    changes.AppendLine($"{property.Name}: From '{originalValue}' to '{currentValue}'");
                }
            }
            return changes.ToString();
        }
    }
}
