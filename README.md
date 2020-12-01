# terraform-infrasetup

Terraform is an Infrastructure as a Code product. In this article, we are going to use Terraform to create a complete VPC with Public Subnet & Private Subnet, Internet Gateway, Nat Gateway, Route Tables, EIP, LoadBalancer and spread across all our defined Availability Zones on AWS. With Terraform, you can easily create a whole new infrastructure by only creating variables, and destroy it with just a single command.

## Prerequisites
- Terraform v0.13.5
- AWS CLI
- IAM Access Key & Secret Key

## Terraform Installation

Please followup [here](https://github.com/TechyCloud/terraform-installation.git) for **Terraform** installation.

**This module will launching the below resources as per given veriables in the AWS console.**
- VPC
- Application LoadBalancer
- Autoscaling Group 
- IAM Roles

You can download full terraform code [here](https://github.com/TechyCloud/terraform-infrasetup/archive/main.zip) to setup the infra.

## VPC Configuration

Once downloaded you can update the below vaiables in **main.tf** file. If you want to add more then two subnets either public or private subnets you can add subnet **CIDR range** like below on respective variables. 

###### Public Sunet CIDR
> public_subnets_cidr = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]

###### Private Subnet CIDR
> private_subnets_cidr = ["10.20.5.0/24", "10.20.6.0/24", 10.20.7.0/24]


Like wise, You can add the **availability zone** in the both(Public & Private) variables.

> public_subnets_Zone = ["ap-south-1a", "ap-south-1a", "ap-south-1b"]

```
VPC_Name =  "Test-VPC"
VPC_CIDR_block = "10.20.0.0/16"
Environment_Name = "DEV"
IGW_Name = "Test-IGW"
Public_RouteTable_Name = "Public-RT"
Private_RouteTable_Name = "Private-RT"
public_subnets_cidr = ["10.20.1.0/24", "10.20.2.0/24"]
public_subnets_Zone = ["ap-south-1a", "ap-south-1a"]
private_subnets_cidr = ["10.20.5.0/24", "10.20.6.0/24"]
private_subnets_Zone = ["ap-south-1b", "ap-south-1b"]
```

Now, You can successfully updated the code to setup the VPC.

## Application LoadBalancer Creation

In the same **main.tf** file you need to update the variables to create a Application LoadBalancer.

```
ALB_SG_Name = "Eig-ALB-SG"
ALB_Name = "Eig-ALB"
Environment_Name = "Staging"
target_group_name = "Eig-ALB-Target"
alb_target_port = "80"
target_helth_path = "/"
target_helth_port = "80"
alb_listener_port = "80"
alb_listener_protocol = "HTTP"
```

In the below variable will take automatically from the output file of VPC modules. Hence, It's not required to update the below variables in **main.tf** file.

```
VPC_ID = "${module.module-vpc_creation.VPC_ID}"
Subnet_1 = "${module.module-vpc_creation.public[1]}"
Subnet_2 = "${module.module-vpc_creation.private[0]}"
```
It's done. Now, You go for update the variables to create the Auto Scaling Group.

## Autoscaling Group Creation

In the same **main.tf** file you need to update the variables to create a Autoscaling Group.

```
Ec2_SG_Name = "eig-ec2-sg"
ami_id = "ami-065567#####23"
instance_type = "t2.micro"
key_name = "######"
launch_config_name = "Test-lc"
```
In the below variable will take automatically from the output file of VPC modules. Hence, It's not required to update the below variables in **main.tf** file.

```
VPC_ID = "${module.module-vpc_creation.VPC_ID}"
alb_target_group = "${module.module-loadbalancer.target_group}"
ASG_Subnet_1 = "${module.module-vpc_creation.public[1]}"
ASG_Subnet_2 = "${module.module-vpc_creation.private[0]}"
```

You have successfully updated the variables to create the Auotscaling Group.

## IAM Role Creation

Need to update the below variable in the same **main.tf** file to create the IAM roles.

```
role-name = "Lambda-Role"
service-name = "ec2.amazonaws.com"
policy-arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
```

The code is ready to launch the resources after updating the variabls in **main.tf** file. 

You can run the below command to initialize the configuration before going to apply the changes in the directory.

> terraform init

Once succeed the above command, You can run the below apply command to launch the resouces in console. For this step, Please keep it ready IAM user access and secret key to apply the changes.   

> terraform apply


**!! Once the command is succeed, You have successfully setup the environment with terraform !!**

###### Thanks for using this Block.
