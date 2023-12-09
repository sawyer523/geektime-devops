variable "password" {
  default = "password123"
}

variable "public_ip" {
  default = ""
}

variable "private_ip" {
  default = ""
}

variable "user" {
  default = "ubuntu"
}

variable "server_name" {
  default = "k3s"
}

variable "cidr_pods" {
  default = "10.0.0.0/16"
}

variable "cidr_services" {
  default = "10.1.0.0/16"
}