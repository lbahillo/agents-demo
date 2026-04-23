interface DashboardCardProps {
  title: string;
  value: string;
  trend: number;
  icon: "activity" | "clock" | "alert-triangle" | "users";
  invertTrend?: boolean;
}

const iconMap: Record<DashboardCardProps["icon"], string> = {
  activity: "📊",
  clock: "⏱️",
  "alert-triangle": "⚠️",
  users: "👥",
};

export function DashboardCard({
  title,
  value,
  trend,
  icon,
  invertTrend = false,
}: DashboardCardProps) {
  const isPositive = invertTrend ? trend <= 0 : trend >= 0;
  const trendColor = isPositive ? "text-emerald-400" : "text-red-400";
  const trendArrow = trend >= 0 ? "↑" : "↓";

  return (
    <div className="rounded-xl border border-gray-800 bg-gray-900 p-6 transition-shadow hover:shadow-lg hover:shadow-indigo-500/5">
      <div className="flex items-center justify-between">
        <span className="text-sm font-medium text-gray-400">{title}</span>
        <span className="text-xl">{iconMap[icon]}</span>
      </div>
      <div className="mt-3 flex items-baseline gap-2">
        <span className="text-3xl font-bold tracking-tight">{value}</span>
        <span className={`text-sm font-medium ${trendColor}`}>
          {trendArrow} {Math.abs(trend)}%
        </span>
      </div>
    </div>
  );
}
