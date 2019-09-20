resource "aws_iam_role" "eks_log_role" {
  name = "${local.prefix}_eks_log_role"

  assume_role_policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
          "Federated": "${aws_iam_openid_connect_provider.for_eks.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${aws_iam_openid_connect_provider.for_eks.url}:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
EOS
}

resource "aws_iam_role_policy_attachment" "eks_log_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = "${aws_iam_role.eks_log_role.name}"
}
