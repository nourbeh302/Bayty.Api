﻿using System.Collections.Concurrent;

namespace AqaratAPIs.Services.Authentication
{
    public class PhoneNumberValidatorTokens
    {
        public ConcurrentDictionary<string, PhoneNumberToken> PhoneNumberTokens { get; set; } = new ConcurrentDictionary<string, PhoneNumberToken>();
    }
}
