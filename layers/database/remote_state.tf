data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "microbank-terraform-state"
    key    = "network/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"

  config = {
    bucket = "microbank-terraform-state"
    key    = "security/terraform.tfstate"
    region = var.aws_region
  }
}