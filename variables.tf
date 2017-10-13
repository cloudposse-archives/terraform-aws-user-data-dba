variable "namespace" {
  default = "global"
}

variable "stage" {
  default = "default"
}

variable "name" {}

variable "db_cluster_name" {
  description = "DB cluster name"
}

variable "db_name" {
  description = "DB name"
}

variable "db_user" {
  description = "DB user"
}

variable "db_password" {
  description = "DB password"
}

variable "db_host" {
  description = "DB host"
}

variable "os" {
  default     = "ubuntu"
  description = "Server OS that will execute user data script"
}

variable "s3_dump_sources" {
  type        = "list"
  default     = []
  description = "S3 buckets used to store dumps"
}
