using Microsoft.AspNetCore.Mvc;
using PulseBoard.Api.Models;
using PulseBoard.Api.Services;

namespace PulseBoard.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public sealed class MetricsController(IMetricsService metricsService) : ControllerBase
{
    [HttpGet("summary")]
    public async Task<ApiResponse<MetricSummary>> GetSummary(CancellationToken ct)
    {
        var summary = await metricsService.GetSummaryAsync(ct);
        return new ApiResponse<MetricSummary> { Data = summary };
    }

    [HttpGet("history")]
    public async Task<ApiResponse<IReadOnlyList<MetricDataPoint>>> GetHistory(
        [FromQuery] string name,
        [FromQuery] int hours = 24,
        CancellationToken ct = default)
    {
        var points = await metricsService.GetHistoryAsync(name, hours, ct);
        return new ApiResponse<IReadOnlyList<MetricDataPoint>> { Data = points };
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ApiResponse<Metric>>> GetById(string id, CancellationToken ct)
    {
        var metric = await metricsService.GetByIdAsync(id, ct);

        if (metric is null)
        {
            return NotFound(new ApiResponse<object> { Data = null!, Success = false, Error = "Metric not found" });
        }

        return new ApiResponse<Metric> { Data = metric };
    }

    [HttpGet]
    public async Task<ApiResponse<object>> List(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        CancellationToken ct = default)
    {
        var (items, totalCount) = await metricsService.ListAsync(page, pageSize, ct);
        return new ApiResponse<object> { Data = new { items, totalCount } };
    }
}
