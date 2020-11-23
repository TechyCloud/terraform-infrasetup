output "lb_arn" {
  value       ="${aws_lb.ALB.arn}" 
  description = "The ARN of the Loadbalancer"
}
output "target_group" {
  value       ="${aws_lb_target_group.alb_target.arn}"
  description = "ALB Target Group Name"
}
