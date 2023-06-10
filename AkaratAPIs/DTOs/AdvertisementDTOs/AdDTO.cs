﻿using Models.Constants;

namespace AqaratAPIs.DTOs.AdvertisementDTOs
{
    public class AdDTO
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public double Price { get; set; }
        public ushort RoomsCount { get; set; }
        public PaymentType PaymentType { get; set; }
        public ushort BathroomsCount { get; set; }
        public string UserId { get; set; }
        public DateTime Date { get; } = DateTime.UtcNow;
        public PropertyType PropertyType { get; set; }
        public bool? HasElevator { get; set; }
        public ushort? NumberOfFlats { get; set; }
        public ushort? NumberOfFloors { get; set; }
        public int? FloorNumber { get; set; }
        public bool? IsFurnished { get; set; }
        public bool? IsVitalSite { get; set; }
        public bool? HasSwimmingPool { get; set; }
    }
}
