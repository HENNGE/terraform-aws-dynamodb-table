resource "aws_dynamodb_table_replica" "replica" {

  global_table_arn       = var.global_table_arn
  kms_key_arn            = var.kms_key_arn
  point_in_time_recovery = var.point_in_time_recovery
  table_class_override   = var.table_class_override

  tags = var.tags
}

module "replica_autoscaling" {
  source = "../autoscaling"

  count = var.autoscaling_enabled ? 1 : 0

  table_name          = split("/", aws_dynamodb_table_replica.replica.global_table_arn)[1]
  autoscaling_read    = merge({ min_capacity = var.read_capacity }, var.autoscaling_read)
  autoscaling_write   = merge({ min_capacity = var.write_capacity }, var.autoscaling_write)
  autoscaling_indexes = var.autoscaling_indexes

  providers = {
    aws        = aws
    aws.no-tag = aws.no-tag
  }
}
