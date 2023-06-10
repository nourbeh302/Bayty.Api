using AqaratAPIs.DTOs.AdvertisementDTOs;
using Models.Entities;
using Models.Constants;

namespace BaytyAPIs.Services.PropertyFactory
{
    public class PropertyFactory : IPropertyFactory
    {
        public Property GetFilledProperty(AdDTO dto, List<HouseBaseImagePath> imagePaths,
            int? adId = null,
            string? userId = null,
            int? hbId = null,
            int? propId = null)
        {
            if (dto != null && dto.PropertyType != null)
            {
                switch (dto.PropertyType)
                {
                    case PropertyType.Building:
                        return GenerateFilledBuilding(dto, imagePaths, adId, userId, hbId, propId);
                    case PropertyType.Villa:
                        return GenerateFilledVilla(dto, imagePaths, adId, userId, hbId, propId);
                    case PropertyType.Apartment:
                        return GenerateFilledApartment(dto, imagePaths, adId, userId, hbId, propId);
                    default:
                        return null;
                }
            }
            return null;
        }

        private Building GenerateFilledBuilding(AdDTO dto, List<HouseBaseImagePath> imagePaths
            ,int? adId = null
            ,string? userId = null
            ,int? houseBaseId = null
            ,int? propId = null)
        {
            var houseBase = new HouseBase
            {
                Id = (houseBaseId.HasValue) ? (int)houseBaseId : 0,
                Address = dto.Address,
                City = dto.City,
                //KitchensCount = dto.KitchensCount,
                Price = dto.Price,
                BathroomsCount = dto.BathroomsCount,
                RoomsCount = dto.RoomsCount,
                HouseBaseImagePaths = imagePaths
            };

            var advertisement = new Advertisement
            {
                Id = (adId.HasValue) ? (int)adId : 0,
                Date = dto.Date,
                Description = dto.Description,
                Title = dto.Title,
                UserId = (userId != null) ?  userId : null,
                HouseBase = houseBase,
                PropertyType = dto.PropertyType,
                PaymentType = dto.PaymentType,
            };

            houseBase.Advertisement = advertisement;

            return new Building
            {
                Id = (propId.HasValue) ? (int)propId: 0,
                HasElevator = dto.HasElevator ?? throw new NullReferenceException(),
                NumberOfFlats = dto.NumberOfFlats ?? throw new NullReferenceException(),
                NumberOfFloors = dto.NumberOfFloors ?? throw new NullReferenceException(),
                HouseBase = houseBase
            };
        }
        private Villa GenerateFilledVilla(AdDTO dto, List<HouseBaseImagePath> imagePaths
            , int? adId = null
            , string? userId = null
            , int? houseBaseId = null
            , int? propId = null)
        {
            var houseBase = new HouseBase
            {
                Id = (houseBaseId.HasValue) ? (int)houseBaseId : 0,
                Address = dto.Address,
                City = dto.City,
                //KitchensCount = dto.KitchensCount,
                Price = dto.Price,
                BathroomsCount = dto.BathroomsCount,
                RoomsCount = dto.RoomsCount,
                HouseBaseImagePaths = imagePaths
            };

            var advertisement = new Advertisement
            {
                Id = (adId.HasValue) ? (int)adId : 0,
                Date = dto.Date,
                Description = dto.Description,
                Title = dto.Title,
                HouseBase = houseBase,
                PropertyType = dto.PropertyType,
                PaymentType = dto.PaymentType,
                UserId = dto.UserId,

            };

            houseBase.Advertisement = advertisement;

            return new Villa
            {
                Id = (propId.HasValue) ? (int)propId : 0,
                HasSwimmingPool = dto.HasSwimmingPool ?? throw new NullReferenceException(),
                HouseBase = houseBase
            };
        }
        private Apartment GenerateFilledApartment(AdDTO dto, List<HouseBaseImagePath> imagePaths
            , int? adId = null
            , string? userId = null
            , int? houseBaseId = null
            , int? propId = null)

        {


            var houseBase = new HouseBase
            {
                Id = (houseBaseId.HasValue) ? (int)houseBaseId : 0,
                Address = dto.Address,
                City = dto.City,
                //KitchensCount = dto.KitchensCount,
                Price = dto.Price,
                BathroomsCount = dto.BathroomsCount,
                RoomsCount = dto.RoomsCount,
                HouseBaseImagePaths = imagePaths
            };

            var advertisement = new Advertisement
            {
                Id = (adId.HasValue) ? (int)adId : 0,
                UserId = (userId != null) ? userId : null,
                Date = dto.Date,
                Description = dto.Description,
                Title = dto.Title,
                HouseBase = houseBase,
                PropertyType = dto.PropertyType,
                PaymentType = dto.PaymentType,
            };

            houseBase.Advertisement = advertisement;

            return new Apartment
            {
                Id = (propId.HasValue) ? (int)propId : 0,
                HasElevator = dto.HasElevator ?? throw new NullReferenceException(),
                FloorNumber = dto.FloorNumber ?? throw new NullReferenceException(),
                IsVitalSite = dto.IsVitalSite ?? throw new NullReferenceException(),
                IsFurnished = dto.IsFurnished ?? throw new NullReferenceException(),
                HouseBase = houseBase
            };
        }
    }
}
