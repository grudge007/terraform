# Variables for VM configuration
variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "template_name" {
  description = "Name of the template to clone"
  type        = string
}

variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "vm_memory" {
  description = "Amount of RAM in MB"
  type        = number
  default     = 1024
}

variable "ci_user" {
  description = "Cloud-init username"
  type        = string
}

variable "ci_passwd" {
  description = "Cloud-init password"
  type        = string
}
