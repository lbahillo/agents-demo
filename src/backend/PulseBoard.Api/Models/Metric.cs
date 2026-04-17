namespace PulseBoard.Api.Models;

public sealed record Metric
{
    public required string Id { get; init; }
    public required string Name { get; init; }
    public required double Value { get; init; }
    public required string Unit { get; init; }
    public Dictionary<string, string> Tags { get; init; } = [];
    public required DateTimeOffset RecordedAt { get; init; }
}

public sealed record MetricSummary
{
    public long TotalRequests { get; init; }
    public double RequestsTrend { get; init; }
    public double AvgResponseTimeMs { get; init; }
    public double ResponseTimeTrend { get; init; }
    public double ErrorRate { get; init; }
    public double ErrorRateTrend { get; init; }
    public int ActiveUsers { get; init; }
    public double ActiveUsersTrend { get; init; }
}

public sealed record MetricDataPoint
{
    public required string Timestamp { get; init; }
    public required double Value { get; init; }
}

public sealed record ApiResponse<T>
{
    public required T Data { get; init; }
    public bool Success { get; init; } = true;
    public string? Error { get; init; }
}
