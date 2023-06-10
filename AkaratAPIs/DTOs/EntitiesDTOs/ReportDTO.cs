using System.ComponentModel.DataAnnotations;

namespace BaytyAPIs.DTOs.EntitiesDTOs
{
    public class ReportDTO
    {
        [MinLength(10)]
        public string Description { get; set; }
        public string ComplainerId { get; set; }
        public string ComplaineeId { get; set; }
    }
}
