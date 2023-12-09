variable "secret_id" {
  default = "Your Access ID"
}

variable "secret_key" {
  default = "Your Access Key"
}

variable "region" {
  description = "The location where instacne will be created"
  default     = "ap-hongkong"
}

variable "availability_zone" {
  default = "ap-hongkong-2"
}

variable "instance_charge_type" {
  type    = string
  default = "SPOTPAID"
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(string)

  default = {
    web = "tf-web"
    dev = "tf-dev"
  }
}

variable "short_name" {
  default = "tf-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "web_cidr" {
  default = "10.0.1.0/24"
}

variable "image_id" {
  default = ""
}

variable "instance_name" {
  default = "terraform-cvm-k8s"
}

variable "password" {
  default = "password123"
}

variable "cpu" {
  default = "4"
}

variable "memory" {
  default = "8"
}

variable "vpc_id" {
  default = ""
}

variable "subnet_id" {
  default = ""
}
