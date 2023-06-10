using Models.Entities;
using Models.IRepositories;
namespace Models.DataStoreContract
{
    public interface IDataStore : IDisposable
    {
        IGenericRepository<Card, int> Cards { get; }
        IGenericRepository<Enterprise, int> Enterprises { get; }
        IGenericRepository<Report, int> Reports { get; }
        IMessageRepository Messages { get; }
        IUserRepository Users { get; }
        IGenericRepository<Apartment, int> Apartments { get; }
        IFavouritePropertiesRepository FavoriteProperties { get; }
        IGenericRepository<Villa, int> Villas { get; }
        IGenericRepository<Building, int> Buildings { get; }
        IAdvertismentRepository Advertisements { get; }
        IGenericRepository<RefreshToken, int> RefreshTokens { get; }
        int Complete();
        Task<int> CompleteAsync();

    }
}
