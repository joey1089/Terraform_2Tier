# --- ec2 / outputs.tf ---

# output "ami_id_ot" {
#   value = aws_instance.web_test.ami
# }

# output "ec2_tag_ot" {
#   value = aws_instance.web_test.tags_all.Name
# }

output "TF_key" {
  value = aws_key_pair.TF_key.key_name
}