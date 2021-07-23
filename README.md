# shared-vpc-demo
The purpose of this repo is to demonstrate how to deploy infrastructure on GCP via Terraform. At a high level we deploy:

1. Shared VPC network (Host Project resides in Management Folder & Service Projects in application folder)
2. 4 subnets (5 total to show how easy to add subnets) in a single region for simplicity
3. Firewall rules to allow internal network connectivity, SSH and Web access from external internet on certain resources.
4. Bastion Host that resides in subnet 01
5. MIG running apache web server that resides in subnet 03 that cannot be accessed via the public internet. 
6. HTTP Load balancer that exposes the apache webserver on port 80 and forwards the incoming traffic to the backend server. 

##  Prerequisites 

## Architecture Diagram
TODO(antoniordz96) add architecture diagram