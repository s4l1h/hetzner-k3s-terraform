#Agents Server
resource "hcloud_server" "agent" {
  depends_on  = [hcloud_ssh_key.k3s]
  count       = var.instance_agents_count
  image       = data.hcloud_image.image.id
  server_type = var.instance_agents_type
  name        = "${var.prefix}-agent-${count.index}"
  datacenter  = var.datacenter
  location    = var.location
  ssh_keys    = list(hcloud_ssh_key.k3s.id)
}


resource "null_resource" "join_node" {
  depends_on = [data.external.join_token]


  triggers = {
    ssh_user        = var.ssh_user
    ssh_port        = var.ssh_port
    ssh_private_key = local.ssh_private_key
  }



  count = var.instance_agents_count
  connection {
    type        = "ssh"
    host        = element(hcloud_server.agent.*.ipv4_address, count.index)
    user        = self.triggers.ssh_user
    port        = self.triggers.ssh_port
    private_key = self.triggers.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      # "apt-get update",
      # "DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes",
      # "DEBIAN_FRONTEND=noninteractive apt-get install open-iscsi --yes",
      data.template_file.agent.rendered
    ]
  }

  provisioner "remote-exec" {
    inline = [
      data.template_file.swapfile.rendered
    ]
  }
}


data "template_file" "agent" {
  template = file("files/agent_install.sh")
  vars = {
    server_ip = hcloud_server.master.ipv4_address
    token     = data.external.join_token.result.token
  }
}

data "external" "join_token" {
  depends_on = [null_resource.copy_configs]
  program    = ["./files/fetch-token.sh"]
}
