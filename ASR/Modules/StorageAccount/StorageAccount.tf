resource "azurerm_storage_account" "res_storage_accounts" {
  for_each                         = { for k, v in var.storage_accounts : k => v }
  location                         = try(var.common.on_premises ? var.common.location : var.common.location_azure, null)
  name                             = "asrstorage${var.common.client}${var.common.application_id}"
  resource_group_name              = try(var.common.on_premises ? var.common.resource_group_name : each.value.resource_group_origin, null)
  account_replication_type         = try(each.value.account_replication_type, null)
  account_tier                     = try(each.value.account_tier, null)
  allow_nested_items_to_be_public  = try(each.value.allow_nested_items_to_be_public, null)
  cross_tenant_replication_enabled = try(each.value.cross_tenant_replication_enabled, null)
  tags                             = merge(var.tags, { ResourceRole : "asrStorage" })
}

