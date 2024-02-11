using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace VPBE.Service.Interfaces
{
    public interface IDBRepository : IDisposable
    {
        Task<TResult> FirstOrDefaultAsync<TResult>(Expression<Func<TResult, bool>> expression, bool track = true) where TResult : class;

        IQueryable<T> FromSql<T>(string sql, params object[] param) where T : class;

        IQueryable<T> FromSql<T>(string formattedSql) where T : class;

        Task<int> ExecuteSqlCommandAsync(string sql, params object[] param);

        Task<int> ExecuteSqlCommandAsync(string formattedSql);

        Task<T> AddAsync<T>(T entity) where T : class;

        Task AddRangeAsync<T>(IEnumerable<T> entities) where T : class;

        int Update<T>(T entity) where T : class;

        int Delete<T>(T entity) where T : class;

        int Delete<T>(Expression<Func<T, bool>> predicate) where T : class;

        int DeleteRange<T>(IEnumerable<T> entities) where T : class;

        Task<int> DeleteAsync<T>(Expression<Func<T, bool>> predicate) where T : class;

        Task<int> SaveChangesAsync(CancellationToken cancellationToken = default(CancellationToken));

        DbContext Context { get; }
    }
}
