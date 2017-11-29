# Define composite variables for resources
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  attributes = ["db"]
}

locals {
  template_path = "${path.module}/templates/${var.flavor}.sh"
}

data "template_file" "default" {
  template = "${file(local.template_path)}"

  vars {
    db_cluster_name         = "${var.db_cluster_name}"
    db_name                 = "${var.db_name}"
    db_user                 = "${var.db_user}"
    db_password             = "${var.db_password}"
    db_host                 = "${var.db_host}"
    name                    = "${var.name}"
    default_dump_source     = "${length(var.s3_dump_sources) > 0 ? element(var.s3_dump_sources, 0) : ""}"
    fix_encoding_use_binary = "${var.fix_encoding_use_binary}"
    encoding                = "${var.result_encoding}"
  }
}

## IAM Role Policy that allows access to S3
resource "aws_iam_policy" "default" {
  name = "${module.label.id}"

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
    actions = ["s3:ListBucket"]

    effect = "Allow"

    resources = "${formatlist("arn:aws:s3:::%s", distinct(split("|", replace(join("|", var.s3_dump_sources), "/\\/[^|]*/", ""))))}"
  }

  statement {
    actions = ["s3:*"]

    effect = "Allow"

    resources = "${concat(formatlist("arn:aws:s3:::%s", var.s3_dump_sources), formatlist("arn:aws:s3:::%s/*", var.s3_dump_sources))}"
  }
}
