output "lambda_arn" {
  value = aws_lambda_function.lambda_employee_node_server.arn
}

output "function_name" {
  value = aws_lambda_function.lambda_employee_node_server.function_name
}