#---EC2_Instances/outputs.tf---

output "web_asg" {
    value = "aws_autoscaling_group.web"
}
