resource "aws_subnet" "db_subnet_1" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
  }
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "db_subnet_group"
  description = "subnet group for db"
  subnet_ids  = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]
  tags = {
  }
}