data "template_file" "default" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    db_cluster_name     = "${var.db_cluster_name}"
    db_name             = "${var.db_name}"
    db_user             = "${var.db_user}"
    db_password         = "${var.db_password}"
    db_host             = "${var.db_host}"
    namespace           = "${var.namespace}"
  }
}