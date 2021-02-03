terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.18.0"
    }
  }
}
# Configure Cloudflare
provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_token
}

data "cloudflare_zones" "main" {
  filter {
    name = var.cloudflare_zone
    # lookup_type = "contains"
  }
}
