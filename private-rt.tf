# Create first private route table and associate it with private subnet in us-west-2a
 
resource "aws_route_table" "dfsc_private_route_table_2a" {
    vpc_id = aws_vpc.dfsc_vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dfsc-nat-gateway-2a.id
  }
    tags =  {
        Name      = "DFSC Private route table 2A"
        Terraform = "True"
  }
}
 
resource "aws_route_table_association" "dfsc-2a" {
    subnet_id = aws_subnet.dfsc-private-2a.id
    route_table_id = aws_route_table.dfsc_private_route_table_2a.id
}
 
# Create second private route table and associate it with private subnet in us-west-2b 
 
resource "aws_route_table" "dfsc_private_route_table_2b" {
    vpc_id = aws_vpc.dfsc_vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dfsc-nat-gateway-2b.id
  }
    tags =  {
        Name      = "DFSC Private route table 2B"
        Terraform = "True"
  }
}
 
resource "aws_route_table_association" "dfsc-2b" {
    subnet_id = aws_subnet.dfsc-private-2b.id
    route_table_id = aws_route_table.dfsc_private_route_table_2b.id
}
