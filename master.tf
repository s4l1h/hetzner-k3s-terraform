# Master server
resource "hcloud_server" "master" {
  depends_on  = [hcloud_ssh_key.k3s]
  image       = data.hcloud_image.image.id
  server_type = var.instance_agents_type
  name        = "${var.prefix}-master"
  datacenter  = var.datacenter
  location    = var.location
  ssh_keys    = list(hcloud_ssh_key.k3s.id)
}

resource "null_resource" "copy_configs" {

  depends_on = [hcloud_server.master]

  triggers = {
    master_ip       = hcloud_server.master.ipv4_address
    ssh_user        = var.ssh_user
    ssh_port        = var.ssh_port
    ssh_private_key = local.ssh_private_key
  }

  connection {
    type        = "ssh"
    host        = self.triggers.master_ip
    user        = self.triggers.ssh_user
    port        = self.triggers.ssh_port
    private_key = self.triggers.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      # "apt-get update",
      # "DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes",
      # "DEBIAN_FRONTEND=noninteractive apt-get install open-iscsi --yes",
      data.template_file.master.rendered
    ]
  }

  provisioner "remote-exec" {
    inline = [
      data.template_file.swapfile.rendered
    ]
  }

  # download /etc/rancher/k3s/k3s.yaml to ./data/k3s.yaml
  provisioner "local-exec" {
    command = "scp -i ${var.ssh_private_key_file} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.ssh_user}@${hcloud_server.master.ipv4_address}:/etc/rancher/k3s/k3s.yaml ./data/k3s.yaml"
  }
  provisioner "local-exec" {
    command = "sed -i '' 's/127.0.0.1/${hcloud_server.master.ipv4_address}/g' ./data/k3s.yaml"
  }
  # download /var/lib/rancher/k3s/server/node-token to ./data/node-token
  provisioner "local-exec" {
    command = "scp -i ${var.ssh_private_key_file} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.ssh_user}@${hcloud_server.master.ipv4_address}:/var/lib/rancher/k3s/server/node-token ./data/node-token"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "rm ./data/k3s.yaml;rm ./data/node-token"
    on_failure = continue
  }
}

data "template_file" "master" {
  template = file("files/server_install.sh")
  vars = {
    server_ip = hcloud_server.master.ipv4_address
  }
}
