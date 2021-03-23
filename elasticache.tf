# DFSC ELASTICACHE SECURITY GROUP

resource "aws_security_group" "dfsc_elasticache_sg" {
  name = "DFSC Elasticache Security Group"
  vpc_id = aws_vpc.dfsc_vpc.id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_groups = [aws_security_group.dfsc_asg_sg.id]
  }
  tags = {
    Name        = "DFSC Elasticache Security Group"
    Terraform   = "true"
  }
}

# CREATE A ELASTICACHE SUBNET GROUP

resource "aws_elasticache_subnet_group" "dfsc_elasticache_subnet" {
  name = "DFSC-Elasticache-Subnet-Group"
  subnet_ids = [
    aws_subnet.dfsc-private-2a.id,
    aws_subnet.dfsc-private-2b.id
    ]
}

# CREATE ELASTICACHE REPLICATION GROUP

resource "aws_elasticache_replication_group" "dfsc_elasticache" {
  automatic_failover_enabled    = "true"
  replication_group_id          = "dfsc-replication-group"
  replication_group_description = "dfsc-elasticache-group"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 2
  engine_version                = "5.0.4"
  parameter_group_name          = "default.redis5.0"
  port                          = 6379
  subnet_group_name = aws_elasticache_subnet_group.dfsc_elasticache_subnet.name
  security_group_ids = [
    aws_security_group.dfsc_elasticache_sg.id
  ]
  tags = {
    Name        = "DFSC Elasticache Replication Group"
    Terraform   = "true"
  }
}