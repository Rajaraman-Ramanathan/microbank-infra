variable "name" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "size" {
  type = number
}

variable "volume_type" {
  type    = string
  default = "gp3"
}

variable "kms_key_arn" {
  type = string
}

variable "snapshot_id" {
  type    = string
  default = null
}

variable "iops" {
  type    = number
  default = 3000
}

variable "throughput" {
  type    = number
  default = 125
}

variable "attach_volume" {
  type    = bool
  default = false
}

variable "instance_id" {
  type    = string
  default = null
}

variable "device_name" {
  type    = string
  default = "/dev/sdf"
}

variable "tags" {
  type    = map(string)
  default = {}
}