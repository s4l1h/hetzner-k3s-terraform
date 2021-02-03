
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.24.0"
    }
  }
}

# Configure the hcloud Provider
provider "hcloud" {
  token = var.hcloud_token
}



resource "hcloud_ssh_key" "k3s" {
  # depends_on = [hcloud_server.master]
  name       = var.ssh_key_name
  public_key = local.ssh_public_key
}

data "hcloud_image" "image" {
  name = var.instance_image
}


data "template_file" "swapfile" {
  template = file("files/create_swapfile.sh")
  vars = {
    swapsize = var.swapsize
  }
}
