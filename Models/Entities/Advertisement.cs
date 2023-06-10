using Models.Constants;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace Models.Entities
{
    public class Advertisement
    {
        public int Id { get; set; }
        public DateTime Date { get; set; }
        public string Description { get; set; }
        public string Title { get; set; }
        public PropertyType PropertyType { get; set; } // Add -- Front Get Detailed Ad
        public string UserId { get; set; }
        [ForeignKey(nameof(UserId))]
        public User User { get; set; }
        [NotMapped]
        public Property property { get; set; }
        public HouseBase HouseBase { get; set; }
        public PaymentType PaymentType { get; set; }
    }
}
