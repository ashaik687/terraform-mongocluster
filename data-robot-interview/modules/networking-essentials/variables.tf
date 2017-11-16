variable "public_subnet_cidr_block_one" {
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr_block_two" {
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr_block_three" {
  default = "10.0.2.0/24"
}

variable "availability_zone_one" {
  default = "us-east-1a"
}

variable "availability_zone_two" {
  default = "us-east-1b"
}

variable "availability_zone_three" {
  default = "us-east-1c"
}

variable "project" {
  default = "ashraf-interview"
}

variable "environment" {
  default = "interview"
}

variable "external_access_cidr_block" {
  default = "0.0.0.0/0"
}

variable "region" {
  default = "us-east-1"
}