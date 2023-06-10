using System.ComponentModel.DataAnnotations;

namespace BaytyAPIs.DTOs.AuthenticationDTOs
{
    public class ResetPasswordDTO
    {
        public string Token { get; set; }
        public string UserId { get; set; }
        public string NewPassword { get; set; }
        [Compare(nameof(NewPassword), ErrorMessage = "Must be exact like new password")]
        public string ConfirmNewPassword { get; set; }
    }
}
