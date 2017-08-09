variable "namespace" {
  default = "global"
}

variable "stage" {
  default = "default"
}

variable "name" {}

variable "db_cluster_name" {}

variable "db_name" {}

variable "db_user" {}

variable "db_password" {}

variable "db_host" {}

variable "s3_dump_sources" {
  type    = "list"
  default = []
}