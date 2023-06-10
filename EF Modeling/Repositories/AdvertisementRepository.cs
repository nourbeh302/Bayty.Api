using Microsoft.EntityFrameworkCore;
using Models.Constants;
using Models.Entities;
using Models.IRepositories;

namespace EF_Modeling.Repositories
{
    public class AdvertisementRepository :
        GenericRepository<Advertisement, int>, IAdvertismentRepository
    {
        private readonly AppDbContext _context;

        public AdvertisementRepository(AppDbContext context) : base(context) => _context = context;

        public async Task AddAdvertisement(Advertisement ad) => await _context.AddAsync(ad.property);

        public async Task<IEnumerable<Advertisement>> GetTwentyAd(int pageSize, int pageNumber)
        {
            return await _context.Advertisements.Skip((pageNumber - 1) * pageSize).Take(pageSize).ToListAsync();
        }
        public async Task<Tuple<List<Advertisement>,int>> SearchAds(int pageSize, int pageNumber, double? minPrice, double? maxPrice, PropertyType? type, OrderDirectionPrice? order, bool? isRent, double? minArea, double? maxArea)
        {
            var query = _context.Advertisements.Include(ad => ad.HouseBase).ThenInclude(hb => hb.HouseBaseImagePaths).AsQueryable();

            if (minPrice.HasValue)
            {
                query = query.Where(a => a.HouseBase.Price >= minPrice);
            }

            if (maxPrice.HasValue) 
            {
                query = query.Where(a => a.HouseBase.Price <= maxPrice);
            }

            if (minArea.HasValue)
            {
                query = query.Where(a => a.HouseBase.Area >= minArea);
            }

            if (maxArea.HasValue) 
            {
                query = query.Where(a => a.HouseBase.Area <= maxArea);
            }

            if (type.HasValue)
            {
                query = query.Where(a => a.PropertyType == type);
            }

            if (isRent.HasValue)
            {
                query = query.Where(a => a.HouseBase.IsForRent == isRent);
            }

            if (order.HasValue)
            {
                switch(order.Value)
                {
                    case OrderDirectionPrice.Ascending:
                        query = query.OrderBy(a => a.HouseBase.Price);
                        break;
                    case OrderDirectionPrice.Descending:
                        query = query.OrderByDescending(a => a.HouseBase.Price);
                        break;
                    default:
                        break;
                }
            }

            int count = query.Count();
            var result = await query.Skip((pageNumber - 1) * pageSize).Take(pageSize).ToListAsync();
            return Tuple.Create(result, count);
            
        }
        public async Task<Advertisement> GetDetailedAd(string adId)
        {
            int id = int.Parse(adId.Split("-").FirstOrDefault()!);
            
            Advertisement ad;
            
            Property property;

            switch (adId.Split("-").Last())
            {
                case "00":
                    var building = await _context.Buildings
                        .Include(b => b.HouseBase)
                        .ThenInclude(hb => hb.Advertisement)
                        .ThenInclude(b=>b.HouseBase.HouseBaseImagePaths)
                        .FirstOrDefaultAsync(c => c.HouseBase.Advertisement.Id == id);

                    ad = building.HouseBase.Advertisement;
                    ad.property = building;
                    ad.PropertyType = PropertyType.Building;
                    break;
                case "11":
                    var villa = await _context.Villas
                        .Include(b => b.HouseBase)
                        .ThenInclude(hb => hb.Advertisement)
                        .ThenInclude(b => b.HouseBase.HouseBaseImagePaths)
                        .FirstOrDefaultAsync(c => c.HouseBase.Advertisement.Id == id);

                    ad = villa.HouseBase.Advertisement;
                    ad.property = villa;
                    ad.PropertyType = PropertyType.Villa;
                    break;
                case "22":
                    var apartment = await _context.Apartments
                        .Include(b => b.HouseBase)
                        .ThenInclude(hb => hb.HouseBaseImagePaths)
                        .Include(hb => hb.HouseBase.Advertisement)
                        .FirstOrDefaultAsync(c => c.HouseBase.Advertisement.Id == id);

                    ad = apartment.HouseBase.Advertisement;
                    ad.property = apartment;
                    ad.PropertyType = PropertyType.Apartment;
                    break;
                default:
                    return null;
            }

            return ad;

        }

        public void UpdateAd(Advertisement advertisement) => _context.Update(advertisement.property);
    }
}
