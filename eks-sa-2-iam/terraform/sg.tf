resource "aws_security_group" "eks_master_pub_api_sg" {
  name        = "${local.prefix}_eks_master_pub_api"
  description = "k8 API allowed access from public network."

  tags = {
    Name = "${local.prefix}_eks_master_pub_api"
  }

  vpc_id = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal_sg" {
  name        = "${local.prefix}_internal_sg"
  description = "internall access all allowed."

  tags = {
    Name = "${local.prefix}_internal_sg"
  }

  vpc_id = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh_sg" {
  name        = "${local.prefix}_ssh_sg"
  description = "allowed ssh access from internet."

  tags = {
    Name = "${local.prefix}_ssh_sg"
  }

  vpc_id = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
