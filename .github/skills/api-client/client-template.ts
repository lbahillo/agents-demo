// API Client Template for PulseBoard
// Add new functions following this pattern to src/frontend/lib/api-client.ts

// Step 1: Define the resource interface
export interface Resource {
  id: string;
  name: string;
  createdAt: string;
}

// Step 2: Define request interfaces (for POST/PUT)
export interface CreateResourceRequest {
  name: string;
}

// Step 3: Create client functions using the existing fetchApi helper

export async function getResourceById(id: string): Promise<Resource> {
  return fetchApi<Resource>(`/api/resources/${encodeURIComponent(id)}`);
}

export async function listResources(
  page: number = 1,
  pageSize: number = 20
): Promise<{ items: Resource[]; totalCount: number }> {
  return fetchApi(`/api/resources?page=${page}&pageSize=${pageSize}`);
}

export async function createResource(
  request: CreateResourceRequest
): Promise<Resource> {
  return fetchApi<Resource>("/api/resources", {
    method: "POST",
    body: JSON.stringify(request),
  });
}

export async function deleteResource(id: string): Promise<void> {
  await fetchApi<void>(`/api/resources/${encodeURIComponent(id)}`, {
    method: "DELETE",
  });
}

// Note: fetchApi is already defined in api-client.ts — do not redefine it.
// The ApiResponse<T> wrapper is automatically unwrapped by fetchApi.
