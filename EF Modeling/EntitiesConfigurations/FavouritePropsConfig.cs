using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Models.Entities;

namespace EF_Modeling.EntitiesConfigurations
{
    public class FavouritePropsConfig : IEntityTypeConfiguration<FavoriteProperties>
    {
        public void Configure(EntityTypeBuilder<FavoriteProperties> builder) =>
            builder.HasKey(fp => new { fp.UserId, fp.AdvertisementId });
    }
}
