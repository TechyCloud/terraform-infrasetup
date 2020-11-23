#This will choose the policy to attache the role
data "aws_iam_policy_document" "role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["${var.service-name}"]
    }
  }
}

#This module will create the roles
resource "aws_iam_role" "roles" {
  name = "${var.role-name}"
  path = "/system/"
  assume_role_policy = data.aws_iam_policy_document.role-policy.json

  tags = {
     Name = "${var.role-name}"
  }
}

#Attaching policy to Role
resource "aws_iam_role_policy_attachment" "attache-policy-role" {
  role       = aws_iam_role.roles.name
  policy_arn = "${var.policy-arn}"
}
