variable "key_name" {
  default = "SmokeKeyPair"
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

variable "route53_zone_name" {
  default = "www.ashrafalishaik.com."
}

variable "route53_record_name_instanace_one" {
  default = "test1"
}

variable "route53_record_name_instanace_two" {
  default = "test2"
}

variable "route53_record_name_instanace_three" {
  default = "test3"
}