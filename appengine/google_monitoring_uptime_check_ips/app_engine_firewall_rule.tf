data "google_monitoring_uptime_check_ips" "ips" {
}

output "echo-ips" {
  value = google_monitoring_uptime_check_ips.ips
}

resource "google_app_engine_firewall_rule" "pkg-gcp_monitoring-location" {
  depends_on = [google_app_engine_applicatio.pkg-gcp]

  for_each = { for ips in data.google_monitoring_uptime_check_ips.ips.uptime_check_ips : ips.ip_address => ips }

  action       = "ALLOW"
  priority     = 1000000000 +  substr(replace(strrev(each.value.ip_address), ".", ""), 0, 8)
  source_range = "${each.value.ip_address}/32"
  description  = "Stackdriver monitoring の監視拠点の IP アドレス(${each.value.region}/${each.value.location})"
}
