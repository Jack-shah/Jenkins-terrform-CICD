for this project
Create a folder ans-terra and cd into it.
here create a file main.tf  and define resource here like instance, security_gruop, key_pair
create provider.tf
generate ssh-keygen to generate a key for connecting with the instance being created
use local-exec provisioner for getting the IP of the infra created.
So this lab is about creating an Ec2 instance on aws 
and  getting Ip of the created instance on the local machine where terraform resource file is (main.tf)
