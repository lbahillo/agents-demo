const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:5062";

export interface MetricSummary {
  totalRequests: number;
  requestsTrend: number;
  avgResponseTimeMs: number;
  responseTimeTrend: number;
  errorRate: number;
  errorRateTrend: number;
  activeUsers: number;
  activeUsersTrend: number;
}

export interface MetricDataPoint {
  timestamp: string;
  value: number;
}

export interface Metric {
  id: string;
  name: string;
  value: number;
  unit: string;
  tags: Record<string, string>;
  recordedAt: string;
}

export interface ApiResponse<T> {
  data: T;
  success: boolean;
  error?: string;
}

async function fetchApi<T>(endpoint: string): Promise<T> {
  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    headers: { "Content-Type": "application/json" },
  });

  if (!response.ok) {
    throw new Error(`API error: ${response.status} ${response.statusText}`);
  }

  const result: ApiResponse<T> = await response.json();

  if (!result.success) {
    throw new Error(result.error ?? "Unknown API error");
  }

  return result.data;
}

export async function getMetricsSummary(): Promise<MetricSummary> {
  return fetchApi<MetricSummary>("/api/metrics/summary");
}

export async function getMetricsHistory(
  metricName: string,
  hours: number
): Promise<MetricDataPoint[]> {
  return fetchApi<MetricDataPoint[]>(
    `/api/metrics/history?name=${encodeURIComponent(metricName)}&hours=${hours}`
  );
}

export async function getMetricById(id: string): Promise<Metric> {
  return fetchApi<Metric>(`/api/metrics/${encodeURIComponent(id)}`);
}

export async function listMetrics(
  page: number = 1,
  pageSize: number = 20
): Promise<{ items: Metric[]; totalCount: number }> {
  return fetchApi(`/api/metrics?page=${page}&pageSize=${pageSize}`);
}
