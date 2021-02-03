resource "cloudflare_record" "master" {
  zone_id = lookup(data.cloudflare_zones.main.zones[0], "id")
  # domain  = var.cloudflare_zone
  name  = var.prefix
  value = var.master.ipv4_address
  type  = "A"
  ttl   = 1
}

resource "cloudflare_record" "master_ipv6" {
  zone_id = lookup(data.cloudflare_zones.main.zones[0], "id")
  # domain  = var.cloudflare_zone
  name  = var.prefix
  value = var.master.ipv6_address
  type  = "AAAA"
  ttl   = 1
}

output "master_zone" {
  value = cloudflare_record.master.hostname
}
output "master_zone_ipv6" {
  value = cloudflare_record.master_ipv6.hostname
}
