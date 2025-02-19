module "autoscaling" {
  source = "./modules/autoscaling"

  count = var.autoscaling_enabled ? 1 : 0

  table_name          = try(aws_dynamodb_table.autoscaled[0].name, aws_dynamodb_table.autoscaled_gsi_ignore[0].name)
  autoscaling_read    = merge({ min_capacity = var.read_capacity }, var.autoscaling_read)
  autoscaling_write   = merge({ min_capacity = var.write_capacity }, var.autoscaling_write)
  autoscaling_indexes = var.autoscaling_indexes

  providers = {
    aws        = aws
    aws.no-tag = aws
  }
}
