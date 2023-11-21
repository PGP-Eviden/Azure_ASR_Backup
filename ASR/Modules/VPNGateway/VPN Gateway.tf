resource "azurerm_public_ip" "res_public_ips" {
  for_each            = { for k, v in var.public_ips : k => v }
  allocation_method   = try(each.value.allocation_method, null)
  location            = try(var.common.location, null)
  name                = "ip-vpn-nwg-asr${var.common.client}${var.common.application_id}"
  resource_group_name = try(var.common.resource_group_name, null)
  sku                 = try(each.value.sku, null)
}

resource "azurerm_virtual_network_gateway" "res_virtual_network_gateways" {
  for_each            = { for k, v in var.virtual_network_gateways : k => v }
  location            = try(var.common.location, null)
  name                = "virtual-ngw-asr${var.common.client}${var.common.application_id}"
  resource_group_name = try(var.common.resource_group_name, null)
  sku                 = try(each.value.sku, null)
  type                = try(each.value.type, null)
  tags                = merge(var.tags, { ResourceRole : "VirtualNetwork" })
  dynamic "ip_configuration" {
    for_each = try(each.value.ip_configuration, [])
    content {
      name                 = try(ip_configuration.value["name"], null)
      public_ip_address_id = try(azurerm_public_ip.res_public_ips[ip_configuration.value["public_ip_address_id"]].id, null)
      # subnet_id            = try(azurerm_subnet.res_subnets[ip_configuration.value["subnet_id"]].id, try(ip_configuration.value["subnet_id__full__"], null))
      subnet_id            = try(var.subnets[ip_configuration.value["subnet_id"]].id, try(ip_configuration.value["subnet_id__full__"], null))
    }
  }
}