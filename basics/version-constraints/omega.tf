terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "1.2.2"
    }
  }
}

resource "local_file" "innovation" {
  filename = var.path
  content  = var.message
}


variable "path" {
    default = "/root/session"
}

variable "message" {
    default = "It's time for innovative ideas.\n"
}
