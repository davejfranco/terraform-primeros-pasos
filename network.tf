#Network
/*
  Componentes de mi red:
  - VPC: 10.0.0.0/16
  - Subnet 1: 10.0.10.0/24
  - Subnet 2: 10.0.20.0/24
  - Subnet 3: 10.0.30.0/24

  - Internet Gateway
  - Tabla de enrutamiento
  - Asociación de tabla de enrutamiento
*/
resource "aws_vpc" "youtube" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "youtube-vpc"
  }
}

resource "aws_subnet" "youtube_sub1" {
  vpc_id            = aws_vpc.youtube.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "youtube-subnet-1"
  }
}

resource "aws_subnet" "youtube_sub2" {
  vpc_id            = aws_vpc.youtube.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "youtube-subnet-2"
  }
}

resource "aws_subnet" "youtube_sub3" {
  vpc_id            = aws_vpc.youtube.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "youtube-subnet-3"
  }
}

resource "aws_internet_gateway" "youtube_igw" {
  vpc_id = aws_vpc.youtube.id
  tags = {
    Name = "youtube-igw"
  }
}

resource "aws_route_table" "youtube_rt" {
  vpc_id = aws_vpc.youtube.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.youtube_igw.id
  }
}

resource "aws_route_table_association" "youtube_sub1" {
  subnet_id      = aws_subnet.youtube_sub1.id
  route_table_id = aws_route_table.youtube_rt.id
}

resource "aws_route_table_association" "youtube_sub2" {
  subnet_id      = aws_subnet.youtube_sub2.id
  route_table_id = aws_route_table.youtube_rt.id
}

resource "aws_route_table_association" "youtube_sub3" {
  subnet_id      = aws_subnet.youtube_sub3.id
  route_table_id = aws_route_table.youtube_rt.id
}
