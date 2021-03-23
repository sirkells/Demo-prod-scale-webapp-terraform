# Create a public route table for Public Subnets
 
resource "aws_route_table" "dfsc-public" {
  vpc_id = aws_vpc.dfsc_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dfsc-igw.id
  }
  tags = {
    Name        = "DFSC Public Route Table"
    Terraform   = "true"
    }
}
 
# Attach a public route table to Public Subnets
 
resource "aws_route_table_association" "dfsc-public-2a-association" {
  subnet_id = aws_subnet.dfsc-public-2a.id
  route_table_id = aws_route_table.dfsc-public.id
}
 
resource "aws_route_table_association" "dfsc-public-2b-association" {
  subnet_id = aws_subnet.dfsc-public-2b.id
  route_table_id = aws_route_table.dfsc-public.id
}