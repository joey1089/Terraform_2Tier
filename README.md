# Terraform_2Tier
Naming conventions to be followed for easy identifications:
outputs.tf - output "instance_type_ot" - here ot stands for output
variables.tf - variables "instance_type_var" here var stands for variable
This helps in reduces a lot of stress in finding which is a variable or a resource name while referencing.

Terraform 2 Tier architecture 

1. Create a highly available two-tier AWS architecture containing the following:
   1. Custom VPC with:
      1. 2 Public Subnets
      2. 2 Private Subnets for the Web Server Tier
      3. 2 Private Subnets for the RDS Tier
   2. 1 Bastion Host in a public subnet
   3. Launch an EC2 Instance with your choice of webserver in each private web tier subnet.
   4. One RDS MySQL Instance (micro) in the private RDS subnets
   5. Security Groups properly configured for needed resources (bastion host, web servers, RDS)
2. Use module blocks for ease of use and re-usability.
3. Deploy this using Terraform Cloud as a CI/CD tool to check your build.

NOTE: DO NOT FORGET TO SET YOUR  ACCESS KEY, SECRET ACCESS KEY AND REGION ENVIRONMENT VARIABLES IN TERRAFORM CLOUD

‌ADVANCED:
1. Replace the EC2 Instances with an Auto Scaling Group for Web Server (in private Web Server subnets) with min of 2 and max of 5 spread across the 2 subnets

Implementation:-
In custom vpc - created
     2 Public Subnets
     2 Private Subnets for the Web Server Tier
     2 Private Subnets for the RDS Tier
In one public subnet created bastion host
In two private subnet created web server in each using auto scaling group
Created security group, one for bastion host, web server and RDS