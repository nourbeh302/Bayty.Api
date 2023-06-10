using Microsoft.EntityFrameworkCore;
using Models.Entities;
using Models.IRepositories;

namespace EF_Modeling.Repositories
{
    public class FavouriteRepository :GenericRepository<FavoriteProperties, int>, IFavouritePropertiesRepository
    {
        private readonly AppDbContext _context;
        public FavouriteRepository(AppDbContext _appDbContext) : base(_appDbContext)
        {
            _context = _appDbContext;
        }

        public async Task<IEnumerable<FavoriteProperties>> GetAllFavourites(string userId)
        {
            return await _context.FavoriteProperties.Include(fp => fp.Advertisement.HouseBase)
                .ThenInclude(hb => hb.HouseBaseImagePaths).Where(fp => fp.UserId == userId).ToListAsync();
        }
    }
}
