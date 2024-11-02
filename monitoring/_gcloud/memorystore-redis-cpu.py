from google.cloud import monitoring_v3
from datetime import datetime, timedelta

# プロジェクト ID を設定
project_id = "Your_Google_Cloud_Project_ID"
client = monitoring_v3.MetricServiceClient()
project_name = f"projects/{project_id}"

# メトリクスのフィルターを設定
interval = monitoring_v3.TimeInterval(
    {
        "end_time": datetime.utcnow(),
        "start_time": datetime.utcnow() - timedelta(minutes=5),
    }
)
results = client.list_time_series(
    request={
        "name": project_name,
        "filter": 'metric.type="redis.googleapis.com/stats/cpu_utilization"',
        "interval": interval,
        "view": monitoring_v3.ListTimeSeriesRequest.TimeSeriesView.FULL,
    }
)

# 結果を表示
for result in results:
    # リソースのラベルからインスタンス名を取得
    instance_name = result.resource.labels.get("instance_id", "Unknown")
    for point in result.points:
        print(f"Instance: {instance_name}, Time: {point.interval.end_time}, CPU Usage: {point.value.double_value}")
