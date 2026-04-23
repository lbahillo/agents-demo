"use client";

import type { MetricDataPoint } from "@/lib/api-client";

interface MetricsChartProps {
  data: MetricDataPoint[];
}

export function MetricsChart({ data }: MetricsChartProps) {
  if (data.length === 0) {
    return (
      <div className="flex h-64 items-center justify-center rounded-xl border border-gray-800 bg-gray-900">
        <p className="text-gray-500">No data available</p>
      </div>
    );
  }

  const maxValue = Math.max(...data.map((d) => d.value));
  const chartHeight = 256;

  return (
    <div className="rounded-xl border border-gray-800 bg-gray-900 p-6">
      <div className="flex h-64 items-end gap-1">
        {data.map((point, index) => {
          const height = (point.value / maxValue) * chartHeight;
          return (
            <div
              key={index}
              className="group relative flex-1"
              title={`${point.timestamp}: ${point.value}`}
            >
              <div
                className="w-full rounded-t bg-indigo-500/80 transition-colors group-hover:bg-indigo-400"
                style={{ height: `${height}px` }}
              />
              {index % 4 === 0 && (
                <span className="absolute -bottom-6 left-0 text-xs text-gray-500">
                  {new Date(point.timestamp).getHours()}:00
                </span>
              )}
            </div>
          );
        })}
      </div>
      <div className="mt-8 flex justify-between text-xs text-gray-500">
        <span>24 hours ago</span>
        <span>Now</span>
      </div>
    </div>
  );
}
