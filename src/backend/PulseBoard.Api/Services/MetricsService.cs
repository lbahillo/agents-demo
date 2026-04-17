using PulseBoard.Api.Models;

namespace PulseBoard.Api.Services;

public interface IMetricsService
{
    Task<MetricSummary> GetSummaryAsync(CancellationToken ct = default);
    Task<IReadOnlyList<MetricDataPoint>> GetHistoryAsync(string metricName, int hours, CancellationToken ct = default);
    Task<Metric?> GetByIdAsync(string id, CancellationToken ct = default);
    Task<(IReadOnlyList<Metric> Items, int TotalCount)> ListAsync(int page, int pageSize, CancellationToken ct = default);
}

public sealed class MetricsService : IMetricsService
{
    public Task<MetricSummary> GetSummaryAsync(CancellationToken ct = default)
    {
        // Simulated metrics for demo purposes
        var summary = new MetricSummary
        {
            TotalRequests = 1_284_392,
            RequestsTrend = 12.5,
            AvgResponseTimeMs = 142,
            ResponseTimeTrend = -3.2,
            ErrorRate = 0.8,
            ErrorRateTrend = -15.0,
            ActiveUsers = 3_847,
            ActiveUsersTrend = 8.1,
        };

        return Task.FromResult(summary);
    }

    public Task<IReadOnlyList<MetricDataPoint>> GetHistoryAsync(
        string metricName,
        int hours,
        CancellationToken ct = default)
    {
        var now = DateTimeOffset.UtcNow;
        var random = new Random(42); // Deterministic seed for consistent demo data

        IReadOnlyList<MetricDataPoint> points = Enumerable
            .Range(0, hours)
            .Select(i => new MetricDataPoint
            {
                Timestamp = now.AddHours(-hours + i).ToString("o"),
                Value = 800 + random.Next(0, 400) + (i * 15), // Upward trend
            })
            .ToList();

        return Task.FromResult(points);
    }

    public Task<Metric?> GetByIdAsync(string id, CancellationToken ct = default)
    {
        var metric = new Metric
        {
            Id = id,
            Name = "http_requests_total",
            Value = 42_567,
            Unit = "count",
            Tags = new() { ["endpoint"] = "/api/metrics", ["method"] = "GET" },
            RecordedAt = DateTimeOffset.UtcNow,
        };

        return Task.FromResult<Metric?>(metric);
    }

    public Task<(IReadOnlyList<Metric> Items, int TotalCount)> ListAsync(
        int page,
        int pageSize,
        CancellationToken ct = default)
    {
        var metrics = new List<Metric>
        {
            new() { Id = "1", Name = "http_requests_total", Value = 42_567, Unit = "count", RecordedAt = DateTimeOffset.UtcNow },
            new() { Id = "2", Name = "response_time_ms", Value = 142, Unit = "ms", RecordedAt = DateTimeOffset.UtcNow },
            new() { Id = "3", Name = "error_rate", Value = 0.8, Unit = "percent", RecordedAt = DateTimeOffset.UtcNow },
            new() { Id = "4", Name = "active_connections", Value = 3_847, Unit = "count", RecordedAt = DateTimeOffset.UtcNow },
        };

        return Task.FromResult<(IReadOnlyList<Metric>, int)>((metrics, metrics.Count));
    }
}
