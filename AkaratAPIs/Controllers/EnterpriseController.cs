using AqaratAPIs.Services.EmailSending;
using BaytyAPIs.DTOs.EnterpriseDTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualBasic;
using Models.DataStoreContract;
using Models.Entities;

namespace BaytyAPIs.Controllers
{
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class EnterpriseController : ControllerBase
    {
        private readonly IDataStore _dataStore;
        private readonly IEmailSenderService _emailService;
        private readonly UserManager<User> _userManager;
        private readonly IConfiguration _config;
        public EnterpriseController(IDataStore dataStore, IEmailSenderService emailService, UserManager<User> userManager,
            IConfiguration config)
        {
            _config = config;
            _dataStore = dataStore;
            _emailService = emailService;
            _userManager = userManager;
        }

        [HttpGet]
        public async Task<ActionResult> GetListOfEnterprises() => Ok(await _dataStore.Enterprises.GetAllAsync());

        [HttpGet("{id}")]
        public async Task<ActionResult> GetEnterprise(int id) => Ok(await _dataStore.Enterprises.FindByIdAsync(id)); 

        [HttpPost]
        public async Task<ActionResult> AddEnterprise(EnterpriseDTO dto)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var enterprise = new Enterprise
                    {
                        Email = dto.Email,
                        Location = dto.Location,
                        IsVerified = false,
                        Name = dto.Name,
                        PhoneNumber = dto.PhoneNumber,
                        TaxRecordNumber = dto.TaxRecordNumber,
                    };
                    await _dataStore.Enterprises.AddAsync(enterprise);
                    await _dataStore.CompleteAsync();
                    return Ok();
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"{ex.Message}");
                    return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
                }
            }
            return BadRequest();
        }



        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult> VerifyEnterprise(int enterpriseId)
        {
            try
            {
                var enterprise = await _dataStore.Enterprises.FindByIdAsync(enterpriseId);
            
                if (enterprise == null)
                    return NotFound();

                var user = new User
                {
                    Email = enterprise.Email,
                    UserName = enterprise.Name,
                };

                await _userManager.CreateAsync(user, _config["DefaultPassForEnterprises"]!);

                await _userManager.AddToRoleAsync(user, "Enterprise-Agent");

                enterprise.Users.Add(user);

                await _dataStore.Enterprises.UpdateAsync(enterprise.Id, enterprise);

                var link = $"https://localhost:4200/reset-password?oldPass={_config["DefaultPassForEnterprises"]}";

                if (await _emailService.SendEmailWithMessageAsync(enterprise.Email, "Your account created successfully now you can login", "Enterprise Account Verification"))
                    return Ok("Go to mail now");
                return StatusCode(StatusCodes.Status503ServiceUnavailable);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, ex.Message);
            }
        }
    }
}
