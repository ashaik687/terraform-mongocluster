# terraform-mongocluster
Three Node Mongo Cluster using Docker on AWS using Terraform

#Pre-requisites
1. Install Terraform.
2. Execute terraform init

#Manual steps Before Starting Deployment
1. Generate a KeyPair and add the name of the KeyPair in variables.tf file in the data-robot-interview folder.
2. Get the pem file and place it in the data-robot-interview folder with 660 permission to be used by terraform to ssh and execute startup scripts
3. Add Environment variables – AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and their corresponding values (Can also be sourced via ~/.bash_profile)

#Provision Resources
From data-robot-interview  folder execute the folowing commands
1. terraform get       ##(To load all Modules)
2. terraform apply     (Enter Region when prompted) ##(To Provision Resources)

#Terminating all Resources
From data-robot-interview  folder execute the folowing command
terraform apply

## Project Design Explanation
Initially Provision the following resources (Listed as per module in the directory structure)

Module 'vpc': 
        - VPC
        - Internet Gateway

Module 'networking-essentials':
        - 3 Pulic Subnets in Three AZs (us-east-1a, us-east-1b, us-east-1c)
        - Custom Route Table for VPC to route traffic to public subnets created above
        - 1 Security Group (This is a bad sg by all means)

main :
    - Route 53 Zone (To be used to add DNS Records for each instance)
    - Gather details of latest Cent OS 7 AMI (CentOS 7 x86_64 2014_07_07 EBS*)
    - Provision 3 mongodb instances with an additional volume of 1000GB
    - Allocate 3 Elastic IPs.
    - Attach them to Provisioned instances.
    - Once Elastic IPs are attached run the 'startup-script.sh' on all three instances.
        - startup-script.sh design:
           - Create a folder for mongodb logs and mount additional volume provisioned above.
           - yum update and install docker.
           - start docker service.
           - pull mongo docker image.
           - Run Mongo Container.
    - On the third node (After above two are provisioned Run setup-replication.sh)
        - setup-replication.sh design
           - Take the public ip addresses of all the nodes and create a config.
           - Initiate a Replica Set
