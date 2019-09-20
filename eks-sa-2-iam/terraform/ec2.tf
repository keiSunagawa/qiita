data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars = {
    endpoint     = "${aws_eks_cluster.main_eks.endpoint}"
    certificate  = "${aws_eks_cluster.main_eks.certificate_authority.0.data}"
    cluster_name = "${local.cluster_name}"
  }
}

resource "aws_launch_configuration" "eks_lc" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.eks_worker_role_profile.id}"
  image_id                    = "ami-0a67c71d2ab43d36f"
  instance_type               = "t2.large"
  name_prefix                 = "${local.prefix}_eks_worker"
  key_name                    = "${local.key_name}"
  enable_monitoring           = false

  security_groups  = ["${aws_security_group.internal_sg.id}", "${aws_security_group.ssh_sg.id}"]
  user_data_base64 = "${base64encode(data.template_file.userdata.rendered)}"
}

resource "aws_autoscaling_group" "eks_asg" {
  name                 = "${local.prefix}_eks_worker_group"
  desired_capacity     = 1
  launch_configuration = "${aws_launch_configuration.eks_lc.id}"
  max_size             = 1
  min_size             = 1
  target_group_arns    = []

  vpc_zone_identifier = aws_subnet.pub_subns.*.id

  tag {
    key                 = "Name"
    value               = "${local.prefix}_eks_worker"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${local.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
