# CREATE ELASTIC IP ADDRESS FOR NAT GATEWAY

  resource "aws_eip" "dfsc-nat1" {
}
  resource "aws_eip" "dfsc-nat2" {
}
  

# CREATE NAT GATEWAY in EU-West-1A

  resource "aws_nat_gateway" "dfsc-nat-gateway-2a" {
  allocation_id = aws_eip.dfsc-nat1.id
  subnet_id     = aws_subnet.dfsc-public-2a.id

  tags = {
    Name        = "Nat Gateway-2a"
    Terraform   = "True"
  }
}

# CREATE NAT GATEWAY in EU-West-1B

resource "aws_nat_gateway" "dfsc-nat-gateway-2b" {
  allocation_id = aws_eip.dfsc-nat2.id
  subnet_id     = aws_subnet.dfsc-public-2b.id

  tags = {
    Name        = "Nat Gateway-2b"
    Terraform   = "True"
  }
}