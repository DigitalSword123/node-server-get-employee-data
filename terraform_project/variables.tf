variable "project" {
  description = "project name for tags and resource naming"
  default     = "employee"
}

variable "name" {
  description = "name to be used as prefix"
  default     = "employee-data-node"
}

variable "env" {
  description = "project environments"
  default = "DEV"
}

variable "owner" {
  description = "owner of this project"
  default     = "ranaamiys70@gmail.com"
}

variable "region" {
  description = "region to which this API to be deployed"
  default     = "ap-south-1"
} 

variable "master_tags" {
  description = "common tags"
  type        = map(string)
}

variable "default_master_tags" {
  description = "common tags"
  type        = map(string)
  default = {
    createdBy  = "ranaamiya70@gmail.com"
    CostCenter = "8723578"
    AlwaysOn   = "Yes"
    platforms  = "Myproject"
    product    = "employee data"
  }
}

variable "_lambda_properties" {
  description = "lambda properties map"
  type        = map(string)
  default = {
    # lambda_zip_file_employee_data = "node-server-employee-data.${version}.zip"
    Lambda_function_name          = "node-server-get-employee-data"
    lambda_zip_file_employee_data = "node-server-get-employee-data.current.zip"
    # lambda_handler                = "index.handler"
  }
}

variable "environment_variables" {
  description = "lambda env variables"
  type        = map(string)
  default     = {}
}