variable "function_name" {
  description = "lambda function name"
}

variable "tags" {
  description = "lambda tags"
}

variable "environment_variables" {
  description = "environment variables"
}

# variable "handler" {
#   description = "lambda handler"
# }

# variable "runtime" {
#   description = "lambda runtime"
# }


variable "filename" {
  description = "name of the zip file"
}

variable "role" {
  description = "lambda execution role"
}

variable "memory" {
  description = "lambda memory"
}

# variable "timeout" {
#   description = "lambda timeout"
# }

# variable "subnet_ids" {
#   description = "which subnets to associate with lambda"
#   type        = list(string)
# }

# variable "security_group_ids" {
#   description = "which security_group_ids to associate with lambda"
#   type        = list(string)
# }

variable "destination-region" {
  type        = string
  default     = "ap-south-1"
  description = "the final region in which lambda will run"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "the final region in which script will run"
}

variable "state-bucket" {
  type        = string
  default     = "state-bucket-name"
  description = "employee-data-node-terraform-state-bucket"
}

variable "ssm-path" {
  description = "the final region in which script will run"
  default     = "/project"
}

# variable "principal_ids" {
#   description = "Resource name"
#   type        = set(string)
# }

variable "env" {
  description = "project environments"
}
