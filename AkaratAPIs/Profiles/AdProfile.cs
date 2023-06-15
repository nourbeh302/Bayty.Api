using AqaratAPIs.DTOs.AdvertisementDTOs;
using AutoMapper;
using BaytyAPIs.DTOs.AdvertisementDTOs;
using Models.Entities;
using Models.Constants;

namespace AqaratAPIs.Profiles
{
    public class AdProfile : Profile
    {
        public AdProfile()
        {
            //CreateMap<Villa, AdWithVillaDTO>()
            //    .ForMember(dest => dest.RoomsCount,      opt => opt.MapFrom(v => v.VillaFeatures.RoomsCount))
            //    .ForMember(dest => dest.Title,           opt => opt.MapFrom(v => v.VillaFeatures.Advertisement.Title))
            //    .ForMember(dest => dest.HasSwimmingPool, opt => opt.MapFrom(v => v.HasSwimmingPool));

            CreateMap<AdDTO, Advertisement>();

            CreateMap<Advertisement, AdCardDTO>()
                .ForPath(dest => dest.IsForRent, opts => opts.MapFrom(src => src.HouseBase.IsForRent))
                .ForPath(dest => dest.Price, opts => opts.MapFrom(src => src.HouseBase.Price))
                .ForPath(dest => dest.Area, opts => opts.MapFrom(src => src.HouseBase.Area))
                .ForPath(dest => dest.MainImagePath, opts => opts.MapFrom(src => "http://localhost:5034" + src.HouseBase.HouseBaseImagePaths.FirstOrDefault()!.ImagePath))
                .ForPath(dest => dest.Id, opts => opts.MapFrom(src =>
                src.PropertyType == PropertyType.Building ? src.Id + "-00" :
                src.PropertyType == PropertyType.Villa ? src.Id + "-11" :
                src.PropertyType == PropertyType.Apartment ? src.Id + "-22" : ""
                ));
        }
    }
}
