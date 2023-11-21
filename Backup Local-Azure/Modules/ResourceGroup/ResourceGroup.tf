resource "azurerm_resource_group" "res_resource_groups" {
  for_each = { for k, v in var.resource_groups : k => v }
  location = try(var.common.location, null)
  name     = try(var.common.resource_group_name)
  tags     = merge(var.tags, { ResourceRole : "ResourceGroup" })
}

