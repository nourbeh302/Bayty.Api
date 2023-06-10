using AqaratAPIs.DTOs.AdvertisementDTOs;
using AutoMapper;
using BaytyAPIs.Constants;
using BaytyAPIs.DTOs.AdvertisementDTOs;
using BaytyAPIs.Services.PropertyFactory;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Models.DataStoreContract;
using Models.Entities;

namespace AqaratAPIs.Controllers
{
    [ApiController]
    [Route("ad/[controller]/[action]")]
    public class AdvertisementController : ControllerBase
    {
        private readonly IDataStore _dataStore;
        private readonly IMapper _mapper;
        private readonly IPropertyFactory _propertyFactory;
        private readonly IWebHostEnvironment _web;
        public AdvertisementController(IDataStore dataStore, IMapper mapper, IPropertyFactory propertyFactory, IWebHostEnvironment web)
        {
            _dataStore = dataStore;
            _mapper = mapper;
            _propertyFactory = propertyFactory;
            _web = web;
        }



        [HttpGet]
        public async Task<ActionResult> GetAll()
        {
            var result = await _dataStore.Advertisements.GetAllAsync();

            if (result.Count() == 0)
            {
                return (NotFound());
            }
            return (Ok(result));
        }

        [HttpGet]
        public async Task<ActionResult> GetDetailedAd(string adId) => Ok(await _dataStore.Advertisements.GetDetailedAd(adId));

        [HttpPut("{adId}")]
        [Authorize(Roles = "Enterprise-Agent,Adatdmin")]
        public async Task<ActionResult> UpdateAdvertisement(string adId, [FromForm] PutAdDTO dto)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var result = await _dataStore.Advertisements.GetDetailedAd(adId);

                    if (result == null)
                        return NotFound();

                    var requestForm = await Request.ReadFormAsync();

                    var imageCountAfterUpdating = (result.HouseBase.HouseBaseImagePaths.Count
                                                + requestForm.Files.Count)
                                                - dto.ChangedImages.Count;

                    List<HouseBaseImagePath> hbip = result.HouseBase.HouseBaseImagePaths;

                    if (imageCountAfterUpdating > 3)
                    {
                        if (dto.ChangedImages.Any())
                        {
                            foreach (var path in dto.ChangedImages)
                            {
                                var ip = hbip.FirstOrDefault(ip => ip.ImagePath == path);

                                var updateImageValidation = ip != null && ip.ImagePath.StartsWith("/Images");

                                if (System.IO.File.Exists(_web.WebRootPath + path) && updateImageValidation)
                                {
                                    System.IO.File.Delete(_web.WebRootPath + path);
                                    hbip.Remove(ip);
                                }
                            }
                        }

                        if (requestForm.Files.Any())
                        {
                            foreach (var file in requestForm.Files)
                                hbip.Add(new HouseBaseImagePath { ImagePath = GenerateImagePath(file) });
                        }

                        Property property = _propertyFactory.GetFilledProperty(dto,
                                                                                hbip,
                                                                                result.Id,
                                                                                result.UserId,
                                                                                result.HouseBase.Id,
                                                                                result.property.Id);

                        _dataStore.Advertisements.UpdateAd(new Advertisement { property = property });

                        await _dataStore.CompleteAsync();

                        return NoContent();
                    }

                    else
                        return BadRequest("Images not enough");

                }
                catch (Exception e)
                {
                    return StatusCode(StatusCodes.Status500InternalServerError, e.Message);
                }
            }
            return BadRequest(ModelState);
        }

        [HttpPost]
        // [Authorize(Policy = "Add-Post")]
        public async Task<ActionResult> AddAdvertisement([FromForm] AdDTO model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    List<HouseBaseImagePath> imagePaths = new List<HouseBaseImagePath>();

                    var request = await Request.ReadFormAsync();

                    var imagesCount = request.Files.Count;

                    if (imagesCount < 3)
                        return BadRequest("Not Enough images");

                    foreach (var image in request.Files)
                        imagePaths.Add(new HouseBaseImagePath { ImagePath = GenerateImagePath(image) });

                    if (Cities.cities.Contains(model.City))
                    {

                        Property property = _propertyFactory.GetFilledProperty(model, imagePaths);

                        await _dataStore.Advertisements.AddAdvertisement(new Advertisement { property = property });

                        await _dataStore.CompleteAsync();

                        return Ok("Advertisement is created successfully");
                    }

                    return BadRequest("Select the proper city please");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Internal Error Happened", ex.Message);
                    return StatusCode(StatusCodes.Status500InternalServerError);
                }
            }
            return BadRequest(ModelState);
        }

        [HttpDelete]
        public async Task<ActionResult> DeleteAdvertisement(string adId)
        {
            var result = await _dataStore.Advertisements.GetDetailedAd(adId);

            if (result == null)
            {
                return NotFound();
            }

            if (int.TryParse(adId.Split("-").First(), out int id))
            {
                try
                {
                    _dataStore.Advertisements.Delete(id);

                    await _dataStore.CompleteAsync();
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error Deleting ad" + ex.Message);
                    return StatusCode(StatusCodes.Status500InternalServerError, "Error While Deletion of ad");
                }

                try
                {
                    DeleteImages(result.HouseBase.HouseBaseImagePaths);
                }
                catch
                {
                    Console.WriteLine("Images not loaded successfully.");
                    return StatusCode(StatusCodes.Status500InternalServerError, "Error While Deletion of Images");
                }

                return NoContent();
            }

            return BadRequest();
        }

        [HttpGet]
        public async Task<ActionResult> SearchAdvertisement([FromQuery] AdSearchDTO dto)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    if (int.TryParse(Request.Headers["page-size"], out int requiredPageSize)
                    &&
                       int.TryParse(Request.Headers["page-number"], out int requiredNumberSize))
                    {   
                        List<Advertisement> ads;
                        int count = 0;
                        (ads, count) = await _dataStore.Advertisements.SearchAds
                            (
                                requiredPageSize, requiredNumberSize, dto.MinPrice, dto.MaxPrice,
                                dto.PropertyType, dto.Order, dto.IsRent, dto.MinPrice, dto.MaxPrice
                            );

                        Response.Headers["Pages-Count"] = count.ToString();

                        var cards = _mapper.Map<List<Advertisement>, List<AdCardDTO>>(ads);

                        return Ok(cards);

                    }
                    return BadRequest("Page Size or Number not mentioned");

                }
                catch (Exception ex)
                {
                    Console.WriteLine($"{ex.Message}");
                    return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
                }
            }
            return BadRequest(ModelState);
        }

        private void DeleteImages(IEnumerable<HouseBaseImagePath> hbIps)
        {
            foreach (var hbIp in hbIps)
            {
                try
                {
                    if (System.IO.File.Exists(_web.WebRootPath + hbIp.ImagePath))
                        System.IO.File.Delete(_web.WebRootPath + hbIp.ImagePath);
                }
                catch { Console.WriteLine("Images not loaded successfully."); }
            }
        }
        private string GenerateImagePath(IFormFile file)
        {
            var imagePath = @"\Images\Properties\" + Guid.NewGuid().ToString() + file.FileName;
            var imageFolder = _web.WebRootPath + imagePath;
            using (var fs = new FileStream(imageFolder, FileMode.Create))
                file.CopyTo(fs);
            return imagePath;
        }


        [HttpGet]
        public async Task<string> TestGet()
        {
            return "Hello";
        }

        [HttpPost]
        public string TestPost(string str) => "Hello" + str;
    }
}
