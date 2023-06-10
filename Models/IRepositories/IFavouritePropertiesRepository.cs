using Models.Entities;

namespace Models.IRepositories
{
    public interface IFavouritePropertiesRepository : IGenericRepository<FavoriteProperties, int>
    {
        Task<IEnumerable<FavoriteProperties>> GetAllFavourites(string userId);
    }
}
