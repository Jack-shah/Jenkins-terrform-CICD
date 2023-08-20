for this project
Create a folder terra-provisoner and cd into it.
here create a file main.tf  and define resource here like instance, security_gruop, key_pair
create provider.tf
generate ssh-keygen to generate a key for connecting with the instance being created
create an index.html file with some text
define file  provisoner to copy file from local folder to remote /tmp/
define remote provisioner to install appche and  cp the index file in/tmp folder to /var/www/html folder
define a connection for provisioners

using remote exec provisioner cd into /var/www/html folder and create index.html file  with some text

So this lab is about creating an Ec2 instance on aws 
installing apache server on it using terraform provisioner.
