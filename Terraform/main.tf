terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://10.0.0.100:8006/api2/json"
}

variable "webserver-subnet" {
  type = list(string)
  default = ["10.0.0.102/24","10.0.0.103/24"]
}

resource "proxmox_lxc" "loadbalancer" {
  target_node  = "cmeadows"
  hostname     = "lb01"
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  ostype       = "ubuntu"
  password     = "BasicLXCContainer"
  unprivileged = true
  onboot = true
  start = true

  ssh_public_keys = file(var.ssh_keys["pub"])

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.0.0.101/24"
    gw = "10.0.0.1"
  }
}

resource "proxmox_lxc" "webserver" {
  count = 2
  target_node  = "cmeadows"
  hostname     = "app0${count.index}"
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  ostype       = "ubuntu"
  password     = "BasicLXCContainer"
  unprivileged = true
  onboot = true
  start = true

  ssh_public_keys = file(var.ssh_keys["pub"])

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = var.webserver-subnet[count.index]
    gw = "10.0.0.1"
  }
}

resource "proxmox_lxc" "database" {
  target_node  = "cmeadows"
  hostname     = "db01"
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  ostype       = "ubuntu"
  password     = "BasicLXCContainer"
  unprivileged = true
  onboot = true
  start = true

  ssh_public_keys = file(var.ssh_keys["pub"])

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.0.0.104/24"
    gw = "10.0.0.1"
  }
}