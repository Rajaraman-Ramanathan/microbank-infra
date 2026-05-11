locals {
  interface_endpoints = {
    ecr_api = {
      service_name = "ecr.api"
    }

    ecr_dkr = {
      service_name = "ecr.dkr"
    }

    sts = {
      service_name = "sts"
    }

    ec2 = {
      service_name = "ec2"
    }

    logs = {
      service_name = "logs"
    }

    monitoring = {
      service_name = "monitoring"
    }

    kms = {
      service_name = "kms"
    }

    secretsmanager = {
      service_name = "secretsmanager"
    }

    ssm = {
      service_name = "ssm"
    }
  }
}

locals {
  gateway_endpoints = {
    s3 = {
      service_name = "s3"
    }
  }
}