#---EC2 Instances/variables.tf---

variable "instance_count" {}
variable "instance_type" {}
variable "public_security_group" {}
variable "public_subnet" {}
variable "private_security_group" {}
variable "private_subnet" {}
variable "volume_size" {}
variable "key_name" {}
variable "public_key_path" {}
variable "target_group" {}