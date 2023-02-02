# --- root / variables.tff ---






# --- database variables ---

variable "db_name" {
  type = string
}

variable "dbuser" {
  type = string
  sensitive = true
}

variable "dbpassword" {
  type = string
  sensitive = true
}

# variable "public_key_path" {
#   type = string
#   sensitive = true
# }