output "master_ip" {
  value = hcloud_server.master.ipv4_address
}
output "master_ipv6" {
  value = hcloud_server.master.ipv6_address
}
#/etc/rancher/k3s/k3s.yaml
# output "master_kubeconfig" {
#   value = fileexists("./data/k3s.yaml") ? file("./data/k3s.yaml") : ""
# }
#/var/lib/rancher/k3s/server/node-token
output "master_node_token" {
  value = data.external.join_token.result.token
}

output "agents_ip" {
  value = [hcloud_server.agent.*.ipv4_address]
}

output "agents_ipv6" {
  value = [hcloud_server.agent.*.ipv6_address]
}
