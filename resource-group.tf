module "resource_group" {
  source = "git::https://github.com/DaradePratik/terraform-azure-modules.git//resource-group?ref=main"

  name     = var.resource_group_name
  location = var.location
}