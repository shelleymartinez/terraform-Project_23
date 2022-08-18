# ---vpc/variables.tf---

variable "vpc_cidr" {
  type = string
}

variable "public_cidrs" {
  type = list(any)

}

variable "private_cidrs" {
  type = list(any)
}

variable "public_subnet_count" {
  type = number
}

variable "private_subnet_count" {
  type = number
}

variable "max_subnets" {
  type = number
}

variable "access_ip" {
  type = string
}

variable "public_security_group" {}
