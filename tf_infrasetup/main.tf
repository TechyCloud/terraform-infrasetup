#This Module Will Creating the VPC with Public and Private Route Tables

module "module-vpc_creation" {
source = "../modules/module-vpc_creation/"
VPC_Name = "Eig-Test"
VPC_CIDR_block = "10.20.0.0/16"
Environment_Name = "Staging"
IGW_Name = "Eig-Test"
Public_RouteTable_Name = "Eig-Public-RT"
Private_RouteTable_Name = "Eig-Private-RT"
public_subnets_cidr = ["10.20.1.0/24", "10.20.2.0/24"]
public_subnets_Zone = ["ap-south-1a", "ap-south-1a"]
private_subnets_cidr = ["10.20.3.0/24", "10.20.4.0/24"]
private_subnets_Zone = ["ap-south-1b", "ap-south-1b"]
}

#This Module Will Creating the ALB

module "module-loadbalancer" {
source = "../modules/module-loadbalancer"
VPC_ID = "${module.module-vpc_creation.VPC_ID}"
Subnet_1 = "${module.module-vpc_creation.public[1]}"
Subnet_2 = "${module.module-vpc_creation.private[0]}"
ALB_SG_Name = "Eig-ALB-SG"
ALB_Name = "Eig-ALB"
Environment_Name = "Staging"
target_group_name = "Eig-ALB-Target"
alb_target_port = "80"
target_helth_path = "/"
target_helth_port = "80"
alb_listener_port = "80"
alb_listener_protocol = "HTTP"
}

#This Module Will Creating the ASG

module "moudle-autoscaling" {
source = "../modules/module-autoscaling"
VPC_ID = "${module.module-vpc_creation.VPC_ID}"
Ec2_SG_Name = "eig-ec2-sg"
ami_id = "ami-0655674012b841023"
instance_type = "t2.micro"
key_name = "ownaccount"
alb_target_group = "${module.module-loadbalancer.target_group}"
ASG_Subnet_1 = "${module.module-vpc_creation.public[1]}"
ASG_Subnet_2 = "${module.module-vpc_creation.private[0]}"
launch_config_name = "Eig-Test-lc"
}

#This Module Will Creating the IAM readonly policy

module "module-iam-roles" {
source = "../modules/module-iam-roles/"
role-name = "Lambda-Role"
service-name = "ec2.amazonaws.com"
policy-arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
}
