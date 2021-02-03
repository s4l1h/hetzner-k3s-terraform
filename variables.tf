
variable "hcloud_token" {
  description = "Hetzner Cloud Token"
}

variable "prefix" {
  description = "The project prefix"
  default     = "srv"
}

variable "swapsize" {
  description = "Swap file size,"
  default     = 1
}
variable "location" {
  description = "Instance Location"
  default     = ""
}
variable "datacenter" {
  description = "Instance datacenter"
  default     = ""
}

variable "instance_agents_type" {
  description = "Agent instance type"
  default     = "cpx11"
}
variable "instance_agents_count" {
  description = "The number of the agents"
  default     = "2"
}

variable "instance_master_type" {
  description = "Master instance type"
  default     = "cpx11"
}

variable "instance_image" {
  default = "debian-10"
}

variable "ssh_key_name" {
  description = "SSH public key name,"
  default     = "k3s-terraform"
}
# SSH
variable "ssh_user" {
  description = "SSH user name to use for remote exec connections,"
  default     = "root"
}

variable "ssh_port" {
  description = "SSH user name to use for remote exec connections,"
  default     = "22"
}
variable "ssh_public_key_file" {
  description = "SSH public key file for remote exec connections,"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_file" {
  description = "SSH private key file for remote exec connections,"
  default     = "~/.ssh/id_rsa"
}

locals {
  ssh_public_key  = fileexists(var.ssh_public_key_file) ? trimspace(file(var.ssh_public_key_file)) : ""
  ssh_private_key = fileexists(var.ssh_private_key_file) ? trimspace(file(var.ssh_private_key_file)) : ""
}
