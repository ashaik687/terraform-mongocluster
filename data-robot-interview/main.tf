module "networking-essentials" {
  source = "modules/networking-essentials"
}

##########################
###   Compute      ###
##########################

data "aws_ami" "centos" {
  most_recent = true
  filter {
    name   = "name"
    values = ["CentOS 7 x86_64 2014_07_07 EBS*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["410186602215"] # Canonical
}

resource "aws_instance" "mongo1" {
  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "m4.large"
  availability_zone           = "${var.availability_zone_one}"
  associate_public_ip_address = false
  key_name                    = "${var.key_name}"
  subnet_id                   = "${module.networking-essentials.public_one_subnet_id}"
  security_groups             = ["${module.networking-essentials.security_group_allow_all}"]
  ebs_block_device{
    device_name               = "/dev/sdg"
    volume_size               = 1000
    volume_type               = "gp2"
    delete_on_termination     = true
  }
  tags {
    Name = "mongo-docker-instance-1"
  }
}

resource "aws_eip" "epi_one" {
  instance = "${aws_instance.mongo1.id}"
  vpc      = true

  provisioner "file" {
    source      = "startup-script.sh"
    destination = "/tmp/startup-script.sh"
    connection {
      type = "ssh"
      host = "${aws_eip.epi_one.public_ip}"
      user = "centos"
      private_key = "${file("${var.key_name}.pem")}"
    }
  }

  provisioner "file" {
    source      = "setup-replication.sh"
    destination = "/tmp/setup-replication.sh"
    connection {
      type = "ssh"
      host = "${aws_eip.epi_one.public_ip}"
      user = "centos"
      private_key = "${file("${var.key_name}.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/startup-script.sh",
      "sudo chmod +x /tmp/setup-replication.sh",
      "sudo bash /tmp/startup-script.sh"
    ]
    connection {
      type = "ssh"
      host = "${aws_eip.epi_one.public_ip}"
      user = "centos"
      private_key = "${file("${var.key_name}.pem")}"
    }
  }
}

#### Instance 2 ####

resource "aws_instance" "mongo2" {
  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "m4.large"
  availability_zone           = "${var.availability_zone_two}"
  associate_public_ip_address = false
  key_name                    = "${var.key_name}"
  subnet_id                   = "${module.networking-essentials.public_two_subnet_id}"
  security_groups             = ["${module.networking-essentials.security_group_allow_all}"]
  ebs_block_device{
    device_name               = "/dev/sdg"
    volume_size               = 1000
    volume_type               = "gp2"
    delete_on_termination     = true
  }
  tags {
    Name = "mongo-docker-instance-2"
  }
}

resource "aws_eip" "epi_two" {
  instance = "${aws_instance.mongo2.id}"
  vpc      = true

  provisioner "file" {
    source      = "startup-script.sh"
    destination = "/tmp/startup-script.sh"
    connection {
      type = "ssh"
      host = "${aws_eip.epi_two.public_ip}"
      user = "centos"
      private_key = "${file("${var.key_name}.pem")}"
    }
  }

  provisioner "file" {
    source      = "setup-replication.sh"
    destination = "/tmp/setup-replication.sh"
    connection {
      type = "ssh"
      host = "${aws_eip.epi_two.public_ip}"
      user = "centos"
      private_key = "${file("${var.key_name}.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/startup-script.sh",
      "sudo chmod +x /tmp/setup-replication.sh",
      "sudo bash /tmp/startup-script.sh"
    ]
    connection {
      type = "ssh"
      host = "${aws_eip.epi_two.public_ip}"
      user = "centos"
      private_key = "${file("${var.key_name}.pem")}"
    }
  }
}

  #### Instance 3 ####

resource "aws_instance" "mongo3" {
  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "m4.large"
  availability_zone           = "${var.availability_zone_three}"
  associate_public_ip_address = false
  key_name                    = "${var.key_name}"
  subnet_id                   = "${module.networking-essentials.public_three_subnet_id}"
  security_groups             = ["${module.networking-essentials.security_group_allow_all}"]
  ebs_block_device{
    device_name               = "/dev/sdg"
    volume_size               = 1000
    volume_type               = "gp2"
    delete_on_termination     = true
  }
  tags {
    Name = "mongo-docker-instance-3"
  }
}

resource "aws_eip" "epi_three" {
  instance = "${aws_instance.mongo3.id}"
  vpc      = true

  provisioner "file" {
    source      = "startup-script.sh"
    destination = "/tmp/startup-script.sh"
    connection {
      type = "ssh"
      host = "${aws_eip.epi_three.public_ip}"
      user = "centos"
      private_key = "${file("${var.key_name}.pem")}"
    }
  }

  provisioner "file" {
    source      = "setup-replication.sh"
    destination = "/tmp/setup-replication.sh"
    connection {
      type = "ssh"
      host = "${aws_eip.epi_three.public_ip}"
      user = "centos"
      private_key = "${file("${var.key_name}.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/startup-script.sh",
      "sudo chmod +x /tmp/setup-replication.sh",
      "sudo bash /tmp/startup-script.sh",
      "sudo bash /tmp/setup-replication.sh ${aws_eip.epi_one.public_ip} ${aws_eip.epi_two.public_ip} ${aws_eip.epi_three.public_ip}"
    ]
    connection {
      type = "ssh"
      host = "${aws_eip.epi_three.public_ip}"
      user = "centos"
      private_key = "${file("${var.key_name}.pem")}"
    }
  }
}

##########################
###   DNS      ###
##########################

resource "aws_route53_zone" "selected" {
  name         = "${var.route53_zone_name}"
}

resource "aws_route53_record" "www_one" {
  zone_id = "${aws_route53_zone.selected.zone_id}"
  name    = "${var.route53_record_name_instanace_one}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.epi_one.public_ip}"]
}

resource "aws_route53_record" "www_two" {
  zone_id = "${aws_route53_zone.selected.zone_id}"
  name    = "${var.route53_record_name_instanace_two}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.epi_two.public_ip}"]
}

resource "aws_route53_record" "www_three" {
  zone_id = "${aws_route53_zone.selected.zone_id}"
  name    = "${var.route53_record_name_instanace_three}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.epi_three.public_ip}"]
}

