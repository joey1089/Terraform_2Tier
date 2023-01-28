# --- root / locals.tf ---

locals {
  key_name = "tfkey-${substr(uuid(), 1, 2)}"
}