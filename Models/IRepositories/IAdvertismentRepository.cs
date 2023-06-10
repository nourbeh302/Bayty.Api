using Models.Constants;
using Models.Entities;
namespace Models.IRepositories
{
    public interface IAdvertismentRepository : IGenericRepository<Advertisement, int>
    {
        void UpdateAd(Advertisement advertisement);
        Task<Advertisement> GetDetailedAd(string adId);
        Task AddAdvertisement(Advertisement ad);
        Task<IEnumerable<Advertisement>> GetTwentyAd(int pageSize, int pageNumber);
        Task<Tuple<List<Advertisement>, int>> SearchAds(int pageSize, int pageNumber, double? minPrice, double? maxPrice, PropertyType? type, OrderDirectionPrice? order, bool? isRent, double? minArea, double? maxArea);
    }
}