resource "null_resource" "default" {
  triggers = {
    id = "${lower(format("%v-%v-%v", var.namespace, var.stage, var.name))}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "default" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    db_cluster_name     = "${var.db_cluster_name}"
    db_name             = "${var.db_name}"
    db_user             = "${var.db_user}"
    db_password         = "${var.db_password}"
    db_host             = "${var.db_host}"
    name                = "${var.name}"
    default_dump_source = "${length(var.s3_dump_sources) > 0 ? element(var.s3_dump_sources, 0) : ''}"
  }
}

## IAM Role Policy that allows access to S3
resource "aws_iam_policy" "default" {
  name = "${null_resource.default.triggers.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = "${data.aws_iam_policy_document.default.json}"
}

data "aws_iam_policy_document" "default" {
  statement {
    actions = [
      "s3:ListAllMyBuckets",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]

    effect = "Allow"

    resources = "${concat(formatlist("arn:aws:s3:::%s", var.s3_dump_sources), formatlist("arn:aws:s3:::%s/*", var.s3_dump_sources))}"
  }
}