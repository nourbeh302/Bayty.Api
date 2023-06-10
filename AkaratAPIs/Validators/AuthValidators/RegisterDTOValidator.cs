using FluentValidation;
using AkaratAPIs.DTOs.AuthenticationDTOs;

namespace AkaratAPIs.Validators.AuthValidators
{
    public class RegisterDTOValidator : AbstractValidator<RegisterDTO>
    {
        public RegisterDTOValidator()
        {
            RuleFor(r => r.Email)
                .EmailAddress();
        }
    }
}
