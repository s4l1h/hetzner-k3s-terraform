resource "cloudflare_record" "agent" {
  zone_id = lookup(data.cloudflare_zones.main.zones[0], "id")
  count   = var.instance_agents_count
  # domain  = var.cloudflare_zone
  name  = "${var.prefix}-agent-${count.index}"
  value = element(var.agents.*.ipv4_address, count.index)
  type  = "A"
  ttl   = 1
}
resource "cloudflare_record" "agent_ipv6" {
  zone_id = lookup(data.cloudflare_zones.main.zones[0], "id")
  count   = var.instance_agents_count
  # domain  = var.cloudflare_zone
  name  = "${var.prefix}-agent-ipv6-${count.index}"
  value = element(var.agents.*.ipv6_address, count.index)
  type  = "AAAA"
  ttl   = 1
}
output "agents_zone" {
  value = [cloudflare_record.agent.*.hostname]
}
output "agents_zone_ipv6" {
  value = [cloudflare_record.agent_ipv6.*.hostname]
}
