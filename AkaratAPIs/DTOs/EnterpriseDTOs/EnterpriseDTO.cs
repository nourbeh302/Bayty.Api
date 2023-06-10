using System.ComponentModel.DataAnnotations;

namespace BaytyAPIs.DTOs.EnterpriseDTOs
{
    public class EnterpriseDTO
    {
        public string Name { get; set; }
        public string? BrandLogoPath { get; set; }
        public string? TaxRecordImagePath { get; set; }
        [RegularExpression("[0-9]{3}-[0-9]{3}-[0-9]{3}")]
        public string TaxRecordNumber { get; set; }
        public IFormFile? Image { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string Location { get; set; }
        public bool IsVerified { get; } = false;
    }
}
