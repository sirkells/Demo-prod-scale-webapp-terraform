# Create and Attach internet gateway

resource "aws_internet_gateway" "dfsc-igw" {
  vpc_id = aws_vpc.dfsc_vpc.id
  tags = {
    Name        = "DFSC Internet Gateway"
    Terraform   = "true"
  }
}