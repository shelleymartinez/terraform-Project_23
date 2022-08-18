#---loadbalancing/variables.tf---

variable "security_groups" {}
variable "public_subnet" {}
variable "web_asg" {}
variable "web_sg" {}
variable "subnet_id" {}
variable "target_group_port" {}
variable "target_group_protocol" {}
variable "vpc_id" {}
variable "lb_healthy_threshold" {}
variable "lb_unhealthy_threshold" {}
variable "lb_timeout" {}
variable "lb_interval" {}
variable "listener_port" {}
variable "listener_protocol" {}