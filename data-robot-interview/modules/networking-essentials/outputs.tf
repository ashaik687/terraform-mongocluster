output "public_one_subnet_id" {
  value = "${aws_subnet.public_one.id}"
}

output "public_two_subnet_id" {
  value = "${aws_subnet.public_two.id}"
}

output "public_three_subnet_id" {
  value = "${aws_subnet.public_three.id}"
}

output "security_group_allow_all" {
  value = "${aws_security_group.allow_all.id}"
}

output "route_table_data_robot" {
  value = "${aws_route_table.datarobot-route-table.id}"
}

output "route_table_public_one_association_id" {
  value = "${aws_route_table_association.public_one_association.id}"
}

output "route_table_public_two_association_id" {
  value = "${aws_route_table_association.public_two_association.id}"
}

output "route_table_public_three_association_id" {
  value = "${aws_route_table_association.public_three_association.id}"
}