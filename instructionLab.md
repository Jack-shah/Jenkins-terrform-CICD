for this project
Create a folder ans-terra and cd into it.
here create a file main.tf  and define resource here like instance, security_gruop, key_pair
create provider.tf
generate ssh-keygen to generate a key for connecting with the instance being created
use local-exec provisioner for getting the IP of the infra created.
So this lab is about creating an Ec2 instance on aws 
and  installing th Apache server on the created infra.
ANSIBLE must be installedon the machine where you running the terrafrom command

======================
Provision EC2 instance using Terraform and install software and deploy app using Ansible
Create an EC2 instance
Create a Security Group and whitelist the port 22 & 8080
Fetch the Public IP

Run Ansible Playbook
- Install Java, Install Tomcat Web Server
- Configure Tomcat
- Deploy Application
