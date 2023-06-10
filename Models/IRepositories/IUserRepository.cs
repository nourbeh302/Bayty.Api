using Models.Entities;

namespace Models.IRepositories
{
    public interface IUserRepository : IGenericRepository<User, string>
    {
        Task DeleteUserAsync(string userId);
    }
}
