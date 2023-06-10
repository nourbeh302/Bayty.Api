using BaytyAPIs.DTOs.EntitiesDTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Models.DataStoreContract;
using Models.Entities;

namespace BaytyAPIs.Controllers
{
    [ApiController]
    [Route("api/[controller]/[action]")]
    [Authorize("Admin")]
    public class ReportController : ControllerBase
    {
        private readonly IDataStore _dataStore;
        public ReportController(IDataStore dataStore)
        {
            _dataStore = dataStore;
        }

        [HttpGet]
        public async Task<ActionResult> GetAll() => Ok(await _dataStore.Reports.GetAllAsync());

        [HttpGet]
        public async Task<ActionResult> GetDetailedReport(int id) => Ok(await _dataStore.Reports.FindByIdAsync(id));

        [HttpPost]
        [Authorize]
        public async Task<ActionResult> AddReport(ReportDTO dto)
        {
            if(ModelState.IsValid)
            {
                if (await EnsureTwoUsersAlreadyExists(dto.ComplaineeId, dto.ComplainerId))
                {
                    var report = new Report
                    {
                         ComplainerId = dto.ComplainerId,
                         ComplaineeId = dto.ComplaineeId,
                         Description = dto.Description,
                         Date = DateTime.Now.ToLocalTime()
                    };

                    await _dataStore.Reports.AddAsync(report);
                    await _dataStore.CompleteAsync();
                    return Ok();
                }

                return BadRequest("No Users Exists");
            }
            return BadRequest(ModelState);
        }
        private async Task<bool> EnsureTwoUsersAlreadyExists(string id1, string id2)
        {
            return await _dataStore.Users.FindByIdAsync(id1) != null && await _dataStore.Users.FindByIdAsync(id2) != null;
        }
    }
}
