## Terraform Project
The purpose of the project is to try different compositions and terraform resources in a basic structure. 

How to use this project:
1. Mandatory: (to be able to initialize Terraform)
    1. In **compose-main.tf** change the S3 bucket variables, there are only placeholders! (Terraform will save the .state file to the provided location)
1. Mandatory: (to be able to login to the EC2 instance with SSH client)
    1. Generate an RSA key pair: 
        1. command: ssh-keygen -t rsa -b 4096 -C "your_email@example.com" and save it as "key".
        1. result: a public key "key.pub" file and a "key" file without extension
    1. Get the whole content of "key.pub" file and assign it to **instances.auto.tfvars** file to pub_key variable.
        1. result: the user will be able to log in to the EC2 instance with the private key
    1. Then SSH to the EC2 instance with the private key "key" file: 
        1. command: ssh ec2-user@<Inet4Address> -o ProxyCommand="/usr/bin/corkscrew <proxy IP> <proxy PORT> %h %p" -i <"key" file location>
        1. OR log in from the jump host with: ssh ec2-user@<Inet4Address> -i <"key" file location>

### Quick commands:
SSH via jumphost:
ssh ec2-user@<Inet4Address> -i Key.pem -o ProxyCommand="/usr/bin/corkscrew <proxy IP> <proxy PORT> %h %p"

CURL via jumphost:
curl <ALB DNS Name> --proxy <proxy IP> <proxy PORT>

SCP via jumphost:
scp -i Key.pem -o ProxyCommand="/usr/bin/corkscrew <proxy IP> <proxy PORT> %h %p" <from> ec2-user@<Inet4Address>:<to>

MySql access from EC2:
mysql -u root -h tf-20180212130810645600000004.cluster-cp8bzwpjnn11.eu-central-1.rds.amazonaws.com -p