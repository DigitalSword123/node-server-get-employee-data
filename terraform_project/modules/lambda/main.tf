data "aws_caller_identity" "current_account" {}

data "aws_ssm_parameter" "lambda-execution-role-arn" {
   name = "/project/${lower(var.env)}/lambda/role"
} 

data "terraform_remote_state" "paramerstore" {
  backend = "s3"
  config = {
    bucket = "node-terraform-state-bucket" #var.state-bucket
    key    = "param-store/${lower(var.environment)}/terraform.tfstate"
    region = var.destination-region
  }
}

data "aws_ssm_parameter" "ssm_params" {
  for_each = data.terraform_remote_state.paramerstore.outputs.ssm_map
  name     = "${var.ssm-path}/${lower(var.environment)}/${each.key}"
}

locals {
  ssm_map = {
    for key, value in data.terraform_remote_state.paramerstore.outputs.ssm_map :
    replace(upper(key), "/", "_") => data.aws_ssm_parameter.ssm_params[key].value
  }
}

# data "archive_file" "employee_lambda"{
#   type="zip"
#   output_path="${path.module}/${var.filename}"
#   source_file = var.filename
# }

# https://stackoverflow.com/questions/70232248/not-able-to-create-zip-file-for-aws-lambda-fx-in-gitlab-through-terraform

resource "aws_iam_role" "iam_for_lambda_node" {
  name = "iam_for_lambda_node_${lower(var.environment)}"

  assume_role_policy = <<-POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}


resource "aws_lambda_function" "lambda_employee_node_server" {
  function_name    = var.function_name
  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)
  role             = aws_iam_role.iam_for_lambda_node.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  memory_size      = "128"
  timeout          = 60

  # vpc_config {
  #   subnet_ids         = var.subnet_ids
  #   security_group_ids = var.security_group_ids
  # }

  # environment {
  #   variables = merge(var.environment_variables, local.ssm_map)
  # }

  tags = var.tags
}

resource "aws_lambda_permission" "allow_invoke_permission" {
  statement_id  = "Allowingtoinvokeotheraccount-877760304415"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_employee_node_server.function_name
  # for_each      = var.principal_ids
  # principal     = "877760304415"
  principal     = "events.amazonaws.com"
}
 

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging_employee" {
  name = "lambda_logging_employee"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.iam_for_lambda_node.name
  policy_arn = "${aws_iam_policy.lambda_logging_employee.arn}"
}