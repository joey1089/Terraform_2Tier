# --- root / outputs.tf ---


# output "AMI_Id" {
#   value = module.my_ec2.ami_id_ot
# }

# output "ec2_tag" {
#   value = module.my_ec2.ec2_tag_ot
# }

output "alb_dns_hostnameurl" {
  value = module.loadbalancing.alb_dns
}
