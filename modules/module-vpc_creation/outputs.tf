output "VPC_ID" {
  value       = "${aws_vpc.VPC_ID.id}"
  description = "The ID of the VPC"
}
output "public" {
  value       = "${aws_subnet.public.*.id}"
  description = "The ID of the Public Subnets"
} 
output "private" {
  value       = "${aws_subnet.private.*.id}"
  description = "The ID of the Private Subnets"
}
