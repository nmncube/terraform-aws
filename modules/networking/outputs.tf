#--- networking/output.tf -----

output "vpc_id" {
    value = aws_vpc.main_vpc.id
}