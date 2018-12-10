variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  type        = "string"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = "string"
}

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

variable "flavor" {
  default     = "debian-systemd"
  description = "Flavor depends of OS and init system"
}

variable "fix_encoding_use_binary" {
  default     = "true"
  description = "Use {source encoding} -> binary -> {result encoding} pattern to fix encoding"
}

variable "result_encoding" {
  default     = "utf8"
  description = "Resulting db encoding"
}

variable "s3_dump_sources" {
  type        = "list"
  default     = []
  description = "S3 buckets used to store dumps"
}
