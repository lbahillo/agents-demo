using Microsoft.AspNetCore.Mvc;
using PulseBoard.Api.Models;
using PulseBoard.Api.Services;

namespace PulseBoard.Api.Controllers;

/// <summary>
/// Template: Replace {Resource} with the actual resource name.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public sealed class ResourceController(IResourceService resourceService) : ControllerBase
{
    [HttpGet]
    public async Task<ApiResponse<object>> List(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        CancellationToken ct = default)
    {
        var (items, totalCount) = await resourceService.ListAsync(page, pageSize, ct);
        return new ApiResponse<object> { Data = new { items, totalCount } };
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<object>>> GetById(
        string id,
        CancellationToken ct = default)
    {
        var result = await resourceService.GetByIdAsync(id, ct);

        if (result is null)
        {
            return NotFound(new ApiResponse<object>
            {
                Data = null!,
                Success = false,
                Error = "Resource not found",
            });
        }

        return new ApiResponse<object> { Data = result };
    }

    [HttpPost]
    public async Task<ActionResult<ApiResponse<object>>> Create(
        [FromBody] object request,
        CancellationToken ct = default)
    {
        var result = await resourceService.CreateAsync(request, ct);
        return CreatedAtAction(nameof(GetById), new { id = "new-id" }, new ApiResponse<object> { Data = result });
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(string id, CancellationToken ct = default)
    {
        await resourceService.DeleteAsync(id, ct);
        return NoContent();
    }
}
