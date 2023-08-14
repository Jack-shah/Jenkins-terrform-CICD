provider "aws" {
  region     = "us-east-1"
}

resource "aws_vpc" "abdulvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "abdulvpc"
  }
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.abdulvpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private"
  }
}
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.abdulvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public"
  }
}
resource "aws_security_group" "abdulsg" {
  name        = "abdulsg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.abdulvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # all
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # all protocol
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "abdulsg"
  }
}
resource "aws_internet_gateway" "abduligw" {
  vpc_id = aws_vpc.abdulvpc.id

  tags = {
    Name = "abduligw"
  }
}
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.abdulvpc.id

  route {
    cidr_block = "0.0.0.0/0"# define where to go or destination            we have not associate a subnet with route table yet 
    gateway_id = aws_internet_gateway.abduligw.id    #define next target for or before final destination
  }
  }
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_key_pair" "samplepem" {
  key_name   = "samplepem"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjhMv/F9TwSS7jkpWGu2vMhW1V/rS6sAFVxI8JqPsSRfSX5VM07PjY9y7z87QcyPATc6UWEzQAWgzTRQxJyW3+i5mfKXQQ3hTTnL5G0lx7mSE7A0afIjJEUj7RJCyfmTWqdTAprWfS3oi/emSvyYCL3YpYbRTUKT5NEVHq+jrPDZzljGWlfBjXKKTl4XE2SKNsjeuH9P2AxZSb5z6iP+dePMX/X7ksGAV3lzcBBfxBdhkEKkZO4zgQgBw0AoCNiILxm/N28H81nzzsiR78pbxUhyXquQOjnewJPDTReqNF300BmHEQsNAt9+0MnLikO6IQ+4Wh0oupNjSg2+L87RgiwO8/AxORZ59UYiIFcToEIbYk6cq8Uw48FO5NQC2JvFgabley02wf5g+nO9NI1CngvcT5O50iAUE0D1/+YK9tap6wF9inA2cke/oazvpDblgnV+rjN6agfrm7nX4d8fxNYFOzdzHHCU4HGCfIOzlfH4DVSsjjb0l0hB/s1ewi/JM= ubuntu@ip-172-31-32-168"
}
resource "aws_instance" "abdul-webserver" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  subnet_id	= aws_subnet.public.id
  key_name	= aws_key_pair.samplepem.id
  vpc_security_group_ids = [aws_security_group.abdulsg.id]
  tags = {
    Name = "abdul-webserver"
  }
}
resource "aws_instance" "abdul-dbserver" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  subnet_id	= aws_subnet.private.id
  key_name	= aws_key_pair.samplepem.id
  vpc_security_group_ids = [aws_security_group.abdulsg.id]
  tags = {
    Name = "abdul-dbserver"
  }
}
resource "aws_eip" "abdulpublicip" {
  instance = aws_instance.abdul-webserver.id
  domain   = "vpc"
}
resource "aws_eip" "abdulpublicipngw" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "abdulngw" {
  allocation_id = aws_eip.abdulpublicipngw.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "abdulngw"
  }
}
resource "aws_route_table" "public-rt-NAT" {
  vpc_id = aws_vpc.abdulvpc.id

  route {
    cidr_block = "0.0.0.0/0"# define where to go or destination            we have not associate a subnet with route table yet
    gateway_id = aws_nat_gateway.abdulngw.id    #define next target for or before final destination
  }
  }
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.public-rt-NAT.id
}
