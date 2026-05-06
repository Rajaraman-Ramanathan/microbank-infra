variable "cluster_name" {
    description = "EKS cluster name"
    type        = string
}

variable "ebs_csi_role_arn" {
    description = "EBS CSI role ARN"
    type        = string
}
variable "alb_irsa_role_arn" {
    description = "ALB IRSA role ARN"
    type        = string
}

variable "tags" {
  description = "Tags for the EKS addons"
  type = map(string)
}