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
        "sudo cp /tmp/primecare-html/* /var/www/html/", # primecare-html is the sample website folder
        "sudo systemctl restart httpd"
    ]
    connection{
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file("./abdul-key")
    }
}
provisioner "file"{
      source="/home/ec2-user/terra-provisioner/primecare-html"
      destination="/tmp/"
      connection{
      type="ssh"
      user="ec2-user"
      host=self.public_ip    
      private_key=file("./abdul-key")
      }
  }

}
resource "aws_key_pair" "abdul-key" {
  key_name   = "abdul-key"
  public_key= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMNJajIZ0Sm7Ua9mw0lYh2xsHmaRbUKBEXBlQUdLS/O1yZ3U0/Nyz3usQaDPiA/2YWWKJSAszakz3K5XF0igbOM3atjY9gfc9k8aAcwmllR+Aw7dTNuEDxkPfvaUmEYiDkNnw+kbyJ8KdqnjOxF9VAHa5GP1kekjn6NkpFAfVQ3+uNeaAyIxa2jWnxHUZnmniR+sMENztV2ALV6V0WQ8qqc2TNlt3jbb4dNyyyIK6mU1/4IQwM2Xy0pdg8b2iDrraDV+OVmNHqk1OGYkbNML1Skp5amq3KvdFoW8uWA70xxlnTiq3G99U9h2km6TqrjJ7I71lK9stPJYYIDNIGVA4ht4LZ7ATznyiAiTR00DS078BVl/zN/PUVRjSJlY6aTh0c0G47imQtphcgGAs/6Dhs55YEDewrfAumwDIX6VZwm6LfQK49psxURIbYp9X1IjGXPxTvY3yxZy7GX1hECRvqNN+QBU0BJoKDz1s01uzRi3O81pEzFFTdfAeUowHUucE= ec2-user@ip-172-31-47-85.ec2.internal"
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
