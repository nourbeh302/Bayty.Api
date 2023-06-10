﻿using AkaratAPIs.DTOs.AuthenticationDTOs;
using AqaratAPIs.DTOs.EntitiesDTOs;
using Models.Entities;

namespace AqaratAPIs.Services.Authentication
{
    public interface IAuthService
    {
        Task<AuthDTO> AddUserAsync(RegisterDTO model);
        Task<AuthDTO> GetUserCredentialsAsync(LoginDTO model);
        Task<string> GetAccessTokenAsync(User user = null, string email = null);
        Task<bool> GetRefreshTokenStateForUserAsync(string email, string refreshToken);
        string GetPhoneNumberToken(string userId);
        Task<bool> VerifyPhoneNumberToken(User user, string token);
        Task<string> UpdateAccountAsync(UserDTO userDto);
    }
}
