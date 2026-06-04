variable "cluster_name" {}
variable "node_role_arn" {}
variable "private_subnet_ids" {}
variable "tags" {}
variable "launch_template_id" {
  type = string
}

variable "launch_template_version" {
  type = string
}

variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    capacity_type  = string
    disk_size      = number

    labels = map(string)

    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
}