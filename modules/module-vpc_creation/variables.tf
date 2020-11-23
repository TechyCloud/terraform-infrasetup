variable "VPC_CIDR_block" {
  type = string
}
variable "VPC_Name" {
  type = string
}
variable "Environment_Name" {
  type = string
}
variable "IGW_Name" {
  type = string
}
variable "Public_RouteTable_Name" {
  type = string
}
variable "Private_RouteTable_Name" {
  type = string
}
variable "public_subnets_cidr" {
  type = "list"
}
variable "public_subnets_Zone" {
  type = "list"
}
variable "private_subnets_cidr" {
  type = "list"
}
variable "private_subnets_Zone" {
  type = "list"
}
