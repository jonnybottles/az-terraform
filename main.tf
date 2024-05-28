# main.tf

module "key_vault" {
  source         = "./modules/pull_key_vault"
  key_vault_name = var.key_vault_name
  key_vault_rg   = var.key_vault_rg
}