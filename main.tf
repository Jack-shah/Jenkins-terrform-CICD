resource "aws_instance" "abdul-webserver" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.abdulsg.id]
  key_name      = "abdul-key"
  tags = {
    Name = "abdul-webserver"
  }  
provisioner "remote-exec"{
    inline =[
        "sudo yum install httpd -y",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd",
        "sudo cd /var/www/html",
         "echo 'Hello wajid' | sudo tee -a /var/www/html/index.html"
    ]
    connection{
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file("./abdul-key")
    }
}
}
resource "aws_key_pair" "abdul-key" {
  key_name   = "abdul-key"
  public_key= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7OTkODuEWNDNptl2tj9e8+LabicPBntcSqhSG8X4qophX86PvTh9Ro9UKhsMKlx5eE7hBBz5F9ntO2egNzE5288x7MvkzYHWoImJlqJT0RHLapSI/eO57UHVmX8uGqUDaQWrBE8cqD40cF2nDW8mGyNF9kkgPZGOQ974QwWMjdgqaF9tsrB//fsjSWFLK+G9asQCpj2OvGN0cHJII4zinXebhlN0JqftcCc8IA+VNLL8h98ywgzCaIERSAlJIt2fyDfRyRTrR4R7B86vAF7IOtVqff0gCXP19nxlU7AkeVoomvvds0lUGo/8EsEsR3gcvfTIq0rWMcEwllNGqvsV2/6jG5kqLFTjCU6e957whT/MnNUqw2M1X1f5mVk0ctfJErAker+bzRZXCqn+xinHN0Sg9+Mb22tGgGHPX67ZjXdLj62FjmF1cWIrM1LNWJ8Ncn2f41nO/KQ9v9cTRnJ2Ryys6rEzJKaE9e2frYw4xklW4EyNou4MKPedGrZ9HDNE= ec2-user@ip-172-31-47-85.ec2.internal"
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


