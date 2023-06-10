namespace Models.Entities
{
    public class FavoriteProperties
    {
        public string? UserId { get; set; }
        public User? User { get; set; }
        public int? AdvertisementId { get; set; }
        public Advertisement? Advertisement { get; set; }
    }
}
