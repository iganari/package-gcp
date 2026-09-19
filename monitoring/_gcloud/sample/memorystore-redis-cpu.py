from google.cloud import monitoring_v3
from datetime import datetime, timedelta
import pytz

# プロジェクト ID を設定
project_id   = "Your_Google_Cloud_Project_ID"
client       = monitoring_v3.MetricServiceClient()
project_name = f"projects/{project_id}"


# JST タイムゾーンを設定
jst = pytz.timezone('Asia/Tokyo')


# 現在のUTC時刻を取得し、JSTに変換
# 直近 5m の結果表示
end_time   = datetime.utcnow().replace(tzinfo=pytz.utc).astimezone(jst)
start_time = end_time - timedelta(minutes=5)


# メトリクスのフィルターを設定
interval = monitoring_v3.TimeInterval(
    {
        "end_time": end_time,
        "start_time": start_time,
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
    node_name     = result.resource.labels.get("node_id", "Unknown")
    print(f"======================================================================================")
    print(f"Instance: {instance_name}")
    print(f"Node: {node_name}")

    for point in result.points:
        # 各インスタインスの CPU を表示
        point_time     = point.interval.end_time
        point_time_jst = point_time.astimezone(jst)
        metorics_value = round(point.value.double_value * 100, 2)
        print(f"---------------------")
        print(f"Time: {point_time_jst}")
        print(f"CPU Usage: {metorics_value} %")

    print(f"======================================================================================")
