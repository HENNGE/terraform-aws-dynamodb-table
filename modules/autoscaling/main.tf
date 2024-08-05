resource "aws_appautoscaling_target" "table_read" {
  count = length(var.autoscaling_read) > 0 ? 1 : 0

  max_capacity       = var.autoscaling_read["max_capacity"]
  min_capacity       = var.autoscaling_read["min_capacity"]
  resource_id        = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  # Workaround for https://github.com/hashicorp/terraform-provider-aws/issues/31839
  provider = aws.no-tag
}

resource "aws_appautoscaling_policy" "table_read_policy" {
  count = length(var.autoscaling_read) > 0 ? 1 : 0

  name               = "DynamoDBReadCapacityUtilization:table/${var.table_name}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_read[0].resource_id
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_in_cooldown  = lookup(var.autoscaling_read, "scale_in_cooldown", var.autoscaling_defaults["scale_in_cooldown"])
    scale_out_cooldown = lookup(var.autoscaling_read, "scale_out_cooldown", var.autoscaling_defaults["scale_out_cooldown"])
    target_value       = lookup(var.autoscaling_read, "target_value", var.autoscaling_defaults["target_value"])
  }
}

resource "aws_appautoscaling_target" "table_write" {
  count = length(var.autoscaling_write) > 0 ? 1 : 0

  max_capacity       = var.autoscaling_write["max_capacity"]
  min_capacity       = var.autoscaling_write["min_capacity"]
  resource_id        = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  # Workaround for https://github.com/hashicorp/terraform-provider-aws/issues/31839
  provider = aws.no-tag
}

resource "aws_appautoscaling_policy" "table_write_policy" {
  count = length(var.autoscaling_write) > 0 ? 1 : 0

  name               = "DynamoDBWriteCapacityUtilization:table/${var.table_name}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.table_write[0].resource_id
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_in_cooldown  = lookup(var.autoscaling_write, "scale_in_cooldown", var.autoscaling_defaults["scale_in_cooldown"])
    scale_out_cooldown = lookup(var.autoscaling_write, "scale_out_cooldown", var.autoscaling_defaults["scale_out_cooldown"])
    target_value       = lookup(var.autoscaling_write, "target_value", var.autoscaling_defaults["target_value"])
  }
}

resource "aws_appautoscaling_target" "index_read" {
  for_each = var.autoscaling_indexes

  max_capacity       = each.value["read_max_capacity"]
  min_capacity       = each.value["read_min_capacity"]
  resource_id        = "table/${var.table_name}/index/${each.key}"
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  # Workaround for https://github.com/hashicorp/terraform-provider-aws/issues/31839
  provider = aws.no-tag
}

resource "aws_appautoscaling_policy" "index_read_policy" {
  for_each = var.autoscaling_indexes

  name               = "DynamoDBReadCapacityUtilization:table/${var.table_name}/index/${each.key}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_read[each.key].resource_id
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    scale_in_cooldown  = lookup(each.value, "read_scale_in_cooldown", var.autoscaling_defaults["scale_in_cooldown"])
    scale_out_cooldown = lookup(each.value, "read_scale_out_cooldown", var.autoscaling_defaults["scale_out_cooldown"])
    target_value       = lookup(each.value, "read_target_value", var.autoscaling_defaults["target_value"])
  }
}

resource "aws_appautoscaling_target" "index_write" {
  for_each = var.autoscaling_indexes

  max_capacity       = each.value["write_max_capacity"]
  min_capacity       = each.value["write_min_capacity"]
  resource_id        = "table/${var.table_name}/index/${each.key}"
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  # Workaround for https://github.com/hashicorp/terraform-provider-aws/issues/31839
  provider = aws.no-tag
}

resource "aws_appautoscaling_policy" "index_write_policy" {
  for_each = var.autoscaling_indexes

  name               = "DynamoDBWriteCapacityUtilization:table/${var.table_name}/index/${each.key}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.index_write[each.key].resource_id
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    scale_in_cooldown  = lookup(each.value, "write_scale_in_cooldown", var.autoscaling_defaults["scale_in_cooldown"])
    scale_out_cooldown = lookup(each.value, "write_scale_out_cooldown", var.autoscaling_defaults["scale_out_cooldown"])
    target_value       = lookup(each.value, "write_target_value", var.autoscaling_defaults["target_value"])
  }
}
