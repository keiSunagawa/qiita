locals {
  sub_params = [
    { az = "ap-northeast-1a", cidr = "172.30.1.0/24" },
    { az = "ap-northeast-1c", cidr = "172.30.2.0/24" }
  ]
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "172.30.0.0/16"
  tags = {
    Name = "${local.prefix}_vpc"
  }
}

resource "aws_internet_gateway" "inet_gw" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags = {
    Name = "${local.prefix}_gw"
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.inet_gw.id}"
  }

  tags = {
    Name = "${local.prefix}_rt"
  }
}

resource "aws_subnet" "pub_subns" {
  count             = "${length(local.sub_params)}"
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${local.sub_params[count.index].cidr}"
  availability_zone = "${local.sub_params[count.index].az}"

  tags = {
    Name = "${local.prefix}_pub_subnet_${local.sub_params[count.index].az}"
  }
}

resource "aws_route_table_association" "pub_ascs" {
  count          = "${length(local.sub_params)}"
  subnet_id      = "${aws_subnet.pub_subns[count.index].id}"
  route_table_id = "${aws_route_table.pub_rt.id}"
}
