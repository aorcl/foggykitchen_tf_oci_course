variable "tenancy_ocid" {}

/*
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
*/

variable "compartment_ocid" {}
variable "region" {}

variable "NewCompartment" {}

variable "public_ssh_key" {}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "VCNname" {
  default = "FoggyKitchenVCN"
}

variable "Shapes" {
  default = "VM.Standard.E2.1"
}

variable "OsImage" {
  # Oracle-Linux-7.7-2020.02.21-0 in Frankfurt
  default = "Oracle-Linux-7.7-2020.02.21-0"
}

variable "service_ports" {
  type = list(string)
  default = ["80","443","22"]
}
