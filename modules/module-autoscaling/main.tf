#Creating Security Group for ALB
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security Group for Launch Configuraion"
  vpc_id      = "${var.VPC_ID}"
  tags = {
    Name = var.Ec2_SG_Name
  }
}

#Creating Launch Configuraion
resource "aws_launch_configuration" "web-lc" {
  #name_prefix = "web-servers"
  name = "${var.launch_config_name}"

  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"

  security_groups = [aws_security_group.ec2_sg.id ]
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}

#Creating Auto Scaling Group
resource "aws_autoscaling_group" "web-asg" {
  name = "${aws_launch_configuration.web-lc.name}-asg"

  min_size             = 1
  desired_capacity     = 2
  max_size             = 4

  health_check_type    = "ELB"

  launch_configuration = aws_launch_configuration.web-lc.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier = ["${var.ASG_Subnet_1}","${var.ASG_Subnet_2}"] 

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
}

#Cerating ASG Policy to Scalingup
resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.web-asg.name
}

#CloudWatch Alarm to Scalingup
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web-asg.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [aws_autoscaling_policy.web_policy_up.arn]
}

#Cerating ASG Ploicy to Scaling down
resource "aws_autoscaling_policy" "web_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.web-asg.name
}

#CloudWatch Alarm to Scaling down
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web-asg.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [aws_autoscaling_policy.web_policy_down.arn]
}

#Autoscaling Attachment
resource "aws_autoscaling_attachment" "ASG_Attach" {
  alb_target_group_arn   = "${var.alb_target_group}"
  autoscaling_group_name = "${aws_autoscaling_group.web-asg.id}"
}
