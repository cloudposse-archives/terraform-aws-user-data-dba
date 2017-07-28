output "user_data" {
  value = "${data.template_file.default.rendered}"
}

output "policy" {
  value = "${aws_iam_policy.default.name}"
}
