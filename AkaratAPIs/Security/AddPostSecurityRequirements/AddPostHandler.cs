using Microsoft.AspNetCore.Authorization;
using Models.DataStoreContract;
using System.Security.Claims;

namespace BaytyAPIs.Security.AddPostSecurityRequirements
{
    public class AddPostHandler : AuthorizationHandler<AddPostRequirement>
    {
        private readonly IDataStore _dataStore;
        public AddPostHandler(IDataStore dataStore)
        {
            _dataStore = dataStore;
        }

        protected async override Task HandleRequirementAsync(AuthorizationHandlerContext context, AddPostRequirement requirement)
        {
            if (context.User.IsInRole("Admin") || context.User.IsInRole("Enterprise-Agent"))
                context.Succeed(requirement);

            var userId = context.User.FindFirstValue(ClaimTypes.NameIdentifier);

            var userAds = await _dataStore.Advertisements.FindAllAsync(ad => ad.UserId == userId);

            var adsPerYear = userAds.GroupBy(ad => ad.Date.Year);

            foreach (var adListPerYear in adsPerYear)
                if (adListPerYear.Count() == 5 && adListPerYear.Key == DateTime.Now.Year)
                    context.Fail();

            context.Succeed(requirement);
        }
    }
}
