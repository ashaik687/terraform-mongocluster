output "datarobot_vpc_id" {
  value = "${aws_vpc.datarobot.id}"
}

output "internet_gateway_datarobot" {
  value = "${aws_internet_gateway.datarobot.id}"
}