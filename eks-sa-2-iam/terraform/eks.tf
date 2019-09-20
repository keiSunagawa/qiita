data "template_file" "eks_configmap" {
  # see https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/add-user-role.html
  template = "${file("${path.module}/eks_configmap.tpl.yml")}"

  vars = {
    role_arn = "${aws_iam_role.eks_worker_role.arn}"
  }
}

resource "aws_eks_cluster" "main_eks" {
  name     = "${local.cluster_name}"
  role_arn = "${aws_iam_role.eks_master_role.arn}"

  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = false
    subnet_ids              = aws_subnet.pub_subns.*.id
    security_group_ids      = ["${aws_security_group.eks_master_pub_api_sg.id}", "${aws_security_group.internal_sg.id}"]
  }
}

output "eks_configmap" {
  value = "${data.template_file.eks_configmap.rendered}"
}
