using Models.Constants;

namespace BaytyAPIs.DTOs.AdvertisementDTOs
{
    public class AdCardDTO
    {
        public string Id { get; set; }
        public string Title { get; set; }
        public PropertyType PropertyType { get; set; }
        public int Area { get; set; }
        public double Price { get; set; }
        public bool IsForRent { get; set; }
        public string MainImagePath { get; set; }
    }
}
