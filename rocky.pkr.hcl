source "virtualbox-iso" "virtualbox" {
  boot_command           = ["<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  disk_size              = "100000"
  guest_additions_path   = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_additions_sha256 = "b81d283d9ef88a44e7ac8983422bead0823c825cbfe80417423bd12de91b8046"
  guest_os_type          = "RedHat_64"
  hard_drive_interface   = "sata"
  headless               = "${var.headless}"
  http_directory         = "http"
  iso_checksum           = "sha256:${var.checksum}"
  iso_url                = "${var.url}"
  shutdown_command       = "${var.shutdown_command}"
  ssh_password           = "vagrant"
  ssh_timeout            = "20m"
  ssh_username           = "vagrant"
  vboxmanage             = [[ "modifyvm", "{{ .Name }}", "--memory", "2024"], [ "modifyvm", "{{ .Name }}", "--cpus", "2" ]]
}

source "vmware-iso" "vmware" {
  boot_command                   = ["<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  disk_size                      = "100000"
  guest_os_type                  = "centos-64"
  headless                       = "${var.headless}"
  http_directory                 = "http"
  iso_checksum                   = "sha256:${var.checksum}"
  iso_url                        = "${var.url}"
  shutdown_command               = "${var.shutdown_command}"
  ssh_password                   = "vagrant"
  ssh_timeout                    = "20m"
  ssh_username                   = "vagrant"
  tools_upload_flavor            = "linux"
  vmx_remove_ethernet_interfaces = "true"
}

build {
  sources = ["source.virtualbox-iso.virtualbox", "source.vmware-iso.vmware"]

  provisioner "shell" {
    execute_command = "sudo {{ .Vars }} sh {{ .Path }}"
    scripts         = ["scripts/vagrant.sh", "scripts/update.sh", "scripts/vmtools.sh", "scripts/zerodisk.sh"]
  }

  post-processor "vagrant" {
    output = "Rocky-${var.version}-x86_64-${source.name}.box"
  }
}

variable "headless" {
  type    = string
  default = "true"
}

variable "shutdown_command" {
  type    = string
  default = "sudo /sbin/halt -p"
}

variable "version" {
  type    = string
  default = "8.4-2105"
}

variable "url" {
  type    = string
  default = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.4-x86_64-dvd1.iso"
}

variable "checksum" {
  type    = string
  default = "ffe2fae67da6702d859cfb0b321561a5d616ce87a963d8a25b018c9c3d52d9a4"
}