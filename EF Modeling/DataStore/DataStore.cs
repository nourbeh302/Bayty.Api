using EF_Modeling.Repositories;
using Models.DataStoreContract;
using Models.Entities;
using Models.IRepositories;

namespace EF_Modeling.DataStore
{
    public class DataStore : IDataStore
    {
        private readonly AppDbContext _context;
        public DataStore(AppDbContext context)
        {
            _context       = context;
            Users          = new UserRepository(context);
            Cards          = new GenericRepository<Card, int>(context);
            Advertisements = new AdvertisementRepository(context);
            RefreshTokens  = new GenericRepository<RefreshToken, int>(context);
            Buildings      = new GenericRepository<Building, int>(context);
            Villas         = new GenericRepository<Villa, int>(context);
            Messages       = new MessageRepository(context);
            FavoriteProperties = new FavouriteRepository(context);
        }

        public IUserRepository Users { get; private set; }
        public IGenericRepository<Card, int> Cards { get; private set; }
        public IGenericRepository<Enterprise, int> Enterprises { get; private set; }
        public IGenericRepository<Report, int> Reports { get; private set; }
        public IMessageRepository Messages { get; private set; }
        public IGenericRepository<RefreshToken, int> RefreshTokens { get; private set; }
        public IGenericRepository<Apartment, int> Apartments { get; private set; }
        public IGenericRepository<Villa, int> Villas { get; private set; }
        public IFavouritePropertiesRepository FavoriteProperties { get; private set; }
        public IGenericRepository<Building, int> Buildings { get; private set; }
        public IAdvertismentRepository Advertisements { get; private set; }

        public int Complete() => _context.SaveChanges();

        public async Task<int> CompleteAsync() => await _context.SaveChangesAsync();

        public void Dispose() => _context.Dispose();
    }
}
