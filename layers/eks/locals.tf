locals {
  node_groups = {
    platform = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 2
      max_size       = 4
      capacity_type  = "ON_DEMAND"
      disk_size      = 50

      labels = {
        role = "platform"
      }

      taints = [
        {
          key    = "workload"
          value  = "platform"
          effect = "NO_SCHEDULE"
        }
      ]
    }

    workloads = {
      instance_types = ["t3.large"]
      desired_size   = 3
      min_size       = 2
      max_size       = 6
      capacity_type  = "SPOT"
      disk_size      = 100

      labels = {
        role = "workload"
      }

      taints = []
    }
  }

  common_tags = {
    Environment = "prod"
    Project     = "eks-platform"
  }
}