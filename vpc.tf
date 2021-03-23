# Define VPC Variable

variable "aws-vpc-cidr" {
  type= string
  default="10.0.0.0/16"
}

# Create VPC

resource "aws_vpc" "dfsc_vpc" {
  cidr_block = var.aws-vpc-cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "DFSC VPC"
    Terrafrom = "True"
  }
}