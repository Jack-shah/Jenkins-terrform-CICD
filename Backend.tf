# this backend.tf file is used for setting remote setup for storing terraform.tf file
terraform {
  backend "s3" {
    bucket = "abdul-tfstat"
    key    = "terraform-tfstate" #folder inside bucket where you will store your terraform.tfstate file
    region = "us-east-1"
    #here dynamodb-table also can be added for locking feature of the terraform.tfstate file but i have not added because i am worried for cost
  }
}
