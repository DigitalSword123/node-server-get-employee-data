# variable "tags" {
#   description = "lambda tags"
# }

# variable "name" {
#   description = "name to be used as prefix"
#   default     = "employee-data-node"
# }

# # variable "security_group_ids" {
# #   description = "which security_group_ids to associate with lambda"
# #   type        = list(string)
# # }

# variable "destination-region" {
#   type        = string
#   default     = "ap-south-1"
#   description = "the final region in which lambda will run"
# }

# variable "environment" {
#   type        = string
#   default     = "dev"
#   description = "the final region in which script will run"
# }

# variable "state-bucket" {
#   type        = string
#   default     = "state-bucket-name"
#   description = "state s3 "
# }

# variable "ssm-path" {
#   description = "the final region in which script will run"
#   default     = "/project"
# }

# # variable "principal_ids" {
# #   description = "Resource name"
# #   type        = set(string)
# # }

# variable "ingresscidr" {
#   type = list(string)
# }

# variable "vpc_id" {
#   description = "vpc to associate security groups with"
# }