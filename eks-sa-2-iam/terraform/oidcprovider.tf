resource "aws_iam_openid_connect_provider" "for_eks" {
  url = "${aws_eks_cluster.main_eks.identity.0.oidc.0.issuer}"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}
