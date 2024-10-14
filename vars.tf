
variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "harish"
}

variable "template_name" {
  description = "Name of the template to clone"
  type        = string
  default     = "ubuntu-cloud"
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

variable "vm_storage" {
  description = "Amount of Storage in GB"
  type        = number
  default     = 10
}

variable "ci_user" {
  description = "Cloud-init username"
  type        = string
  default     = "user"
}

variable "ci_passwd" {
  description = "Cloud-init password"
  type        = string
  default     = "pass"
}
        