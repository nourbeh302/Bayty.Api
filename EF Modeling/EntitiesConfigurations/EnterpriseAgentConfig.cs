using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Models.Entities;

namespace EF_Modeling.EntitiesConfigurations
{
    public class EnterpriseAgentConfig : IEntityTypeConfiguration<EnterpriseAgent>
    {
        public void Configure(EntityTypeBuilder<EnterpriseAgent> builder)
        {
            builder.HasKey(ea => new { ea.UserId, ea.EnterpriseId });
        }
    }
}
