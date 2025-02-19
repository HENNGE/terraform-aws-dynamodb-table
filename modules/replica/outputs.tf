output "arn" {
  description = "ARN of the DynamoDB replica table"
  value       = aws_dynamodb_table_replica.replica.arn
}
