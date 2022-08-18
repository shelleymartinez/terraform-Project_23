#---root/main.tf---

module "vpc" {
  source               = "./vpc"
  vpc_cidr             = local.vpc_cidr
  access_ip            = var.access_ip
  public_security_group = module.vpc.public_security_group
  public_subnet_count  = 3
  private_subnet_count = 3
  max_subnets          = 20
  public_cidrs         = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs        = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}

module "loadbalancing" {
  source                 = "./loadbalancing"
  subnet_id              = "subnet-0c8200bfb84cb5525"
  public_subnet = module.vpc.public_subnet
  target_group_port      = 80
  target_group_protocol  = "HTTP"
  vpc_id                 = module.vpc.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 80
  listener_protocol      = "HTTP"
  web_sg                 = module.vpc.web_sg
  web_asg                = module.EC2_Instances.web_asg
  security_groups        = module.vpc.web_sg
}

module "EC2_Instances" {
  source                 = "./EC2_Instances"
  public_subnet          = module.vpc.public_subnet
  private_subnet         = module.vpc.private_subnet
  public_security_group = module.vpc.public_security_group
  private_security_group = module.vpc.web_sg
  instance_count         = 1
  instance_type          = "t2.micro"
  volume_size            = 10
  key_name               = "web"
  public_key_path        = "/home/ec2-user/.ssh/key_three_tier.pub"
  target_group    = module.loadbalancing.target_group

}