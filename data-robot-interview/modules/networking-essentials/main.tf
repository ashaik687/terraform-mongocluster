module "vpc" {
  source = "../vpc"
}

#############
## Subnets ##
#############
resource "aws_subnet" "public_one" {
  vpc_id                  = "${module.vpc.datarobot_vpc_id}"
  cidr_block              = "${var.public_subnet_cidr_block_one}"
  availability_zone       = "${var.availability_zone_one}"
  map_public_ip_on_launch = true

  tags {
    Name        = "PublicSubnet_One"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public_two" {
  vpc_id                  = "${module.vpc.datarobot_vpc_id}"
  cidr_block              = "${var.public_subnet_cidr_block_two}"
  availability_zone       = "${var.availability_zone_two}"
  map_public_ip_on_launch = true

  tags {
    Name        = "PublicSubnet_Two"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public_three" {
  vpc_id                  = "${module.vpc.datarobot_vpc_id}"
  cidr_block              = "${var.public_subnet_cidr_block_three}"
  availability_zone       = "${var.availability_zone_three}"
  map_public_ip_on_launch = true

  tags {
    Name        = "PublicSubnet_Three"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

##########################
###   Security Groups ###
##########################
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${module.vpc.datarobot_vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

##########################
###   Route Tables     ###
##########################
resource "aws_route_table" "datarobot-route-table" {
  vpc_id = "${module.vpc.datarobot_vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${module.vpc.internet_gateway_datarobot}"
  }

  tags {
    Name = "datarobot-routetable"
  }
}

resource "aws_route_table_association" "public_one_association" {
  subnet_id      = "${aws_subnet.public_one.id}"
  route_table_id = "${aws_route_table.datarobot-route-table.id}"
}

resource "aws_route_table_association" "public_two_association" {
  subnet_id      = "${aws_subnet.public_two.id}"
  route_table_id = "${aws_route_table.datarobot-route-table.id}"
}

resource "aws_route_table_association" "public_three_association" {
  subnet_id      = "${aws_subnet.public_three.id}"
  route_table_id = "${aws_route_table.datarobot-route-table.id}"
}


