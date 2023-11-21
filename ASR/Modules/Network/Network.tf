resource "azurerm_virtual_network" "res_virtual_networks" {
  for_each            = { for k, v in var.virtual_networks : k => v }
  address_space       = try(each.value.address_space, null)
  location            = try(var.common.location, null)
  name                = "vnet-${var.common.Location_short}-${var.common.client}${var.common.application_id}"
  resource_group_name = try(var.common.resource_group_name, null)
  tags                = merge(var.tags, { ResourceRole : "VirtualNetwork" })
}

resource "azurerm_subnet" "res_subnets" {
  for_each             = { for k, v in var.subnets : k => v }
  name                 = try(each.value.name, "vnet-subnet-asr${var.common.client}${var.common.application_id}") 
  resource_group_name  = try(var.common.resource_group_name, null)
  virtual_network_name = azurerm_virtual_network.res_virtual_networks["0"].name
  address_prefixes     = try(each.value.address_prefixes, null)
}

