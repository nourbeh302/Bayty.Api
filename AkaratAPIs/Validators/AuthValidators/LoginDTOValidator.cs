﻿using FluentValidation;
using AkaratAPIs.DTOs.AuthenticationDTOs;

namespace AkaratAPIs.Validators.AuthValidators
{
    public class LoginDTOValidator : AbstractValidator<LoginDTO>
    {
        public LoginDTOValidator()
        {
            //RuleFor(l => l.Email)
            //    .EmailAddress(FluentValidation.Validators.EmailValidationMode.AspNetCoreCompatible)
            //    .NotEmpty()
            //    .NotNull();

            RuleFor(l => l.Password)
                .NotEmpty()
                .NotNull()
                .MaximumLength(60)
                .MinimumLength(8);
        }
    }
}
