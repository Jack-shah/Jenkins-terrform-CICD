resource "aws_instance" "abdul-webserver" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.abdulsg.id]
  key_name      = "abdul-key"
  tags = {
    Name = "abdul-webserver"
  }
provisioner "local-exec"{
command="sleep 30; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${aws_instance.abdul-webserver.public_ip}, -u ec2-user --private-key ./abdul-key tomcat.yml"
}
}
resource "aws_key_pair" "abdul-key" {
  key_name   = "abdul-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnKBHzfVBAhs0yef/Mt52losrvIF8SeL6/MkjeTZKCkIQx3Gk3q2TW+142HDSqPS50Gqh2vncS9vLVye69Sx4DhT4zX5bG2j8MLDKyepJERWA+02x1DxaEi5g0c9oKAMWAgMZTnUlBd7/dWcjwP8JwhNBi0kwDg9eZC+YZyy2zveIRMmuxWLeVoysNiePOvrXQ3wUU1ta+3CdCbQFXeEdQlnrzKa3TX4UAKBWVl0tPytWHSRfqqgStzPXBmnhmT7Pc0RJw8wRADx+/t2DnDKIrwMbGq2BmyXmhqERApA9PvYnmOMLtju6jiRpSrRrd4MCLNGF1V38Q/fjHDfh6nT7zvk0RRnZf2sJGi/XopSzdWP+uqNO7eL5Ghah+9wN3q9VrDKoqb/TkXW+dkWy8ZNA+JyZhpijcnWPiJLO6R+/3+ZNJ2qfsvnrygDzo3AffIBaMcejQzPEktAkg0kdmpbWDCcCoRnNAM74u5jQL2O++HFcPw2XqcPXeR9QkWKeL0ws= ec2-user@ip-172-31-47-85.ec2.internal"
}

resource "aws_security_group" "abdulsg" {
  name        = "abdulsg"
  description = "Allow TLS inbound traffic"

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
