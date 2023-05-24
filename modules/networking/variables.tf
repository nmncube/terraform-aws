# ----- networking/variables -----

variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}
 
variable "public_cidrs" {
    type = list
    default = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "private_cidrs" {
    type = list
    default = ["10.0.1.0/24", "10.0.3.0/24"]
} 

variable "private_data_cidrs" {
    type = list
    default = ["10.0.5.0/24", "10.0.6.0/24"]
}
 
variable "public_sn_count" {
    type = number
    default = 2
}

variable "private_app_sn_count" {
    type = number
    default = 2
}

variable "private_data_sn_count" {
    type = number
    default = 2
}