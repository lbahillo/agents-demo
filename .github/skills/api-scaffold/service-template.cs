using PulseBoard.Api.Models;

namespace PulseBoard.Api.Services;

/// <summary>
/// Template: Replace {Resource} with the actual resource name.
/// Define proper types instead of 'object' for real implementations.
/// </summary>
public interface IResourceService
{
    Task<(IReadOnlyList<object> Items, int TotalCount)> ListAsync(int page, int pageSize, CancellationToken ct = default);
    Task<object?> GetByIdAsync(string id, CancellationToken ct = default);
    Task<object> CreateAsync(object request, CancellationToken ct = default);
    Task DeleteAsync(string id, CancellationToken ct = default);
}

public sealed class ResourceService : IResourceService
{
    public Task<(IReadOnlyList<object> Items, int TotalCount)> ListAsync(
        int page,
        int pageSize,
        CancellationToken ct = default)
    {
        // TODO: Implement with actual data access
        throw new NotImplementedException();
    }

    public Task<object?> GetByIdAsync(string id, CancellationToken ct = default)
    {
        // TODO: Implement with actual data access
        throw new NotImplementedException();
    }

    public Task<object> CreateAsync(object request, CancellationToken ct = default)
    {
        // TODO: Implement with actual data access
        throw new NotImplementedException();
    }

    public Task DeleteAsync(string id, CancellationToken ct = default)
    {
        // TODO: Implement with actual data access
        throw new NotImplementedException();
    }
}
