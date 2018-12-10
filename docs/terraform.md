
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| db_cluster_name | DB cluster name | string | - | yes |
| db_host | DB host | string | - | yes |
| db_name | DB name | string | - | yes |
| db_password | DB password | string | - | yes |
| db_user | DB user | string | - | yes |
| fix_encoding_use_binary | Use {source encoding} -> binary -> {result encoding} pattern to fix encoding | string | `true` | no |
| flavor | Flavor depends of OS and init system | string | `debian-systemd` | no |
| name | Name  (e.g. `app` or `cluster`) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| result_encoding | Resulting db encoding | string | `utf8` | no |
| s3_dump_sources | S3 buckets used to store dumps | list | `<list>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy_arn | User data script iam policy that should be executed on startup |
| user_data | User data script that should be executed on startup |

