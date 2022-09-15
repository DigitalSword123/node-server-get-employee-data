# tis .tfstate file in s3 bucket will store already provisioned
# infrastrucrures like lambda, bucket which are created previous terraform
terraform {
  backend "s3" {
    bucket     = "node-terraform-state-bucket"
    encrypt    = false
    region     = "ap-south-1"
  }
}
