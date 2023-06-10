using AutoMapper;
using BaytyAPIs.DTOs.AdvertisementDTOs;
using BaytyAPIs.DTOs.FavoritePropertiesDTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Models.DataStoreContract;
using Models.Entities;

namespace BaytyAPIs.Controllers
{
    [ApiController]
    [Route("api/[controller]/[action]")]
    [Authorize]
    public class FavoriteProperitesController : ControllerBase
    {
        private readonly IDataStore _dataStore;
        private readonly IMapper _mapper;
        public FavoriteProperitesController(IDataStore dataStore, IMapper mapper)
        {
            _dataStore = dataStore;
            _mapper = mapper;
        }

        [HttpPost]
        public async Task<ActionResult> AddToMyFavorites(FavoritePropertyDTO dto)
        {
            var fp = new FavoriteProperties
            {
                UserId = dto.UserId,
                AdvertisementId = dto.PropertyId
            };
            try
            {
                await _dataStore.FavoriteProperties.AddAsync(fp);
                await _dataStore.CompleteAsync();
                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }

        [HttpPost]
        public async Task<ActionResult> RemoveFromMyFavorites(FavoritePropertyDTO dto)
        {
            if (ModelState.IsValid)
            {
                var fp = new FavoriteProperties
                {
                    UserId = dto.UserId,
                    AdvertisementId = dto.PropertyId
                };

                try
                {
                    var result = await _dataStore.FavoriteProperties.FindOneAsync(fp => fp.UserId == dto.UserId && fp.AdvertisementId == dto.PropertyId);

                    if (result == null)
                        return NotFound();
                    if (fp.AdvertisementId.HasValue)
                    {
                        await _dataStore.FavoriteProperties.DeleteUserDependentItemAsync((int)fp.AdvertisementId, fp.UserId);
                        await _dataStore.CompleteAsync();
                        return NoContent();
                    }

                    return BadRequest();
                }
                catch (Exception ex)
                {
                    return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
                }
            }
            return BadRequest();
        }

        [HttpPost]
        public async Task<ActionResult> GetAllMyFavorites(string userId)
        {
            try
            {
                var result = (await _dataStore.FavoriteProperties.GetAllFavourites(userId)).Select(fp => fp.Advertisement);

                if (result == null)
                    return NotFound();


                var cards = _mapper.Map<IEnumerable<Advertisement>, IEnumerable<AdCardDTO>>(result);

                return Ok(cards);

            } catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }
    }
}
