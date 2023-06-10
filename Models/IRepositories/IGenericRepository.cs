﻿using System.Linq.Expressions;

namespace Models.IRepositories
{
    public interface IGenericRepository<T, K> where T : class
    {
        Task<T> GetAsync(K id);
        Task<IEnumerable<T>> GetAllAsync();
        Task AddAsync(T item);
        Task AddRangeAsync(IEnumerable<T> items);
        Task UpdateAsync(K id, T item);
        T Delete(K id);
        Task<T> DeleteUserDependentItemAsync(K id1, string id2);
        Task<T> FindByIdAsync(K id);
        Task<T> FindOneAsync(Expression<Func<T, bool>> criteria);
        Task<IEnumerable<T>> FindAllAsync(Expression<Func<T, bool>> criteria);
        int GetCount();
    }
}