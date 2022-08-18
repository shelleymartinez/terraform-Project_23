#---EC2 Instances/main.tf---

data "aws_ami" "instance_ami" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*.0-x86_64-gp2"]
  }
}

resource "random_id" "instance_id" {
  byte_length = 2
  count       = var.instance_count
}

resource "aws_key_pair" "instance_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_launch_configuration" "bastion_host" {
  name_prefix     = "bastion_host"
  image_id            = data.aws_ami.instance_ami.id
  instance_type   = var.instance_type
  security_groups = [var.public_security_group]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion_host_asg" {
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.bastion_host.name
  vpc_zone_identifier  = var.public_subnet
}

resource "aws_launch_template" "web" {
  name_prefix            = "web"
  image_id                  = data.aws_ami.instance_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.private_security_group]
  key_name               = "aws_key_pair.web_auth.id"
  user_data = filebase64("./userdata.tftpl")
  
   tags = {
    Name = "web"
  }
}

resource "aws_autoscaling_group" "web_asg" {
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
  
   launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "web" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  lb_target_group_arn   = var.target_group
}