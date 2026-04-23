"use client";

import { useEffect, useState } from "react";
import { DashboardCard } from "@/components/DashboardCard";
import { MetricsChart } from "@/components/MetricsChart";
import { getMetricsSummary, getMetricsHistory } from "@/lib/api-client";
import type { MetricSummary, MetricDataPoint } from "@/lib/api-client";

export default function DashboardPage() {
  const [summary, setSummary] = useState<MetricSummary | null>(null);
  const [history, setHistory] = useState<MetricDataPoint[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchData() {
      try {
        const [summaryData, historyData] = await Promise.all([
          getMetricsSummary(),
          getMetricsHistory("requests", 24),
        ]);
        setSummary(summaryData);
        setHistory(historyData);
      } catch (error) {
        console.error("Failed to load dashboard data:", error);
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, []);

  if (loading) {
    return (
      <div className="flex h-screen items-center justify-center">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-indigo-500 border-t-transparent" />
      </div>
    );
  }

  return (
    <main className="min-h-screen p-8">
      <header className="mb-8">
        <h1 className="text-3xl font-bold tracking-tight">PulseBoard</h1>
        <p className="mt-1 text-gray-400">Real-time application analytics</p>
      </header>

      <section className="mb-8 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <DashboardCard
          title="Total Requests"
          value={summary?.totalRequests.toLocaleString() ?? "—"}
          trend={summary?.requestsTrend ?? 0}
          icon="activity"
        />
        <DashboardCard
          title="Avg Response Time"
          value={`${summary?.avgResponseTimeMs ?? 0}ms`}
          trend={summary?.responseTimeTrend ?? 0}
          icon="clock"
          invertTrend
        />
        <DashboardCard
          title="Error Rate"
          value={`${summary?.errorRate ?? 0}%`}
          trend={summary?.errorRateTrend ?? 0}
          icon="alert-triangle"
          invertTrend
        />
        <DashboardCard
          title="Active Users"
          value={summary?.activeUsers.toLocaleString() ?? "—"}
          trend={summary?.activeUsersTrend ?? 0}
          icon="users"
        />
      </section>

      <section>
        <h2 className="mb-4 text-xl font-semibold">Request Volume (24h)</h2>
        <MetricsChart data={history} />
      </section>
    </main>
  );
}
