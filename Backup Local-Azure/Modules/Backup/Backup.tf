# resource "azurerm_backup_policy_vm" "res_backup_policy_vms" {
#   for_each            = { for k, v in var.backup_policy_vms : k => v }
#   resource_group_name = try(var.common.resource_group_name, null)
#   name                = try(each.value.name, null)
#   recovery_vault_name = azurerm_recovery_services_vault.res_recovery_services_vaults["0"].name
#   policy_type         = try(each.value.policy_type, null)
#   dynamic "backup" {
#     for_each = try(each.value.backup, [])
#     content {
#       frequency     = try(backup.value["frequency"], null)
#       time          = try(backup.value["time"], null)
#       hour_duration = try(backup.value["hour_duration"], null)
#       hour_interval = try(backup.value["hour_interval"], null)
#     }
#   }
#   dynamic "retention_daily" {
#     for_each = try(each.value.retention_daily, [])
#     content {
#       count = try(retention_daily.value["count"], null)
#     }
#   }
# }

resource "azurerm_recovery_services_vault" "res_recovery_services_vaults" {
  for_each            = { for k, v in var.recovery_services_vaults : k => v }
  name                = "bakvault${var.common.client}${var.common.application_id}"
  resource_group_name = try(var.common.resource_group_name, null)
  sku                 = try(each.value.sku, null)
  location            = try(var.common.location, null)
  public_network_access_enabled = each.value.public_network_access_enabled
  
}

resource "azurerm_private_dns_zone" "res_private_dns_zones" {
  for_each            = { for k, v in var.private_dns_zones : k => v }
  resource_group_name = try(var.common.resource_group_name, null)
  name                = try(each.value.name, null)
}

resource "azurerm_private_dns_a_record" "res_private_dns_a_records" {
  for_each            = { for k, v in var.private_dns_a_records : k => v }
  name                = try("private-dns-record-bakvault${var.common.client}${var.common.application_id}", null)
  records             = try(each.value.records, null)
  resource_group_name = try(var.common.resource_group_name, null)
  ttl                 = try(each.value.ttl, null)
  zone_name           = azurerm_private_dns_zone.res_private_dns_zones[each.value.zone_name].name
}

resource "azurerm_private_endpoint" "res_private_endpoints" {
  for_each                      = { for k, v in var.private_endpoints : k => v }
  # custom_network_interface_name = try(each.value.custom_network_interface_name, null)
  location                      = try(var.common.location, null)
  name                          = try("private-endpoint-bakvault${var.common.client}${var.common.application_id}", null)
  resource_group_name           = try(var.common.resource_group_name, null)
  subnet_id                     = try(var.subnets[each.value.subnet_id].id, null)
  dynamic "private_dns_zone_group" {
    for_each = try(each.value.private_dns_zone_group, [])
    content {
      name                 = try(private_dns_zone_group.value["name"], null)
      private_dns_zone_ids = [try(azurerm_private_dns_zone.res_private_dns_zones[private_dns_zone_group.value["private_dns_zone_ids"]].id, null)]
    }
  }
  dynamic "private_service_connection" {
    for_each = try(each.value.private_service_connection, [])
    content {
      is_manual_connection           = try(private_service_connection.value["is_manual_connection"], null)
      name                           = try("private-service-connection-bakvault${var.common.client}${var.common.application_id}", null)
      private_connection_resource_id = try(azurerm_recovery_services_vault.res_recovery_services_vaults[private_service_connection.value["private_connection_resource_id"]].id, null)
      #private_connection_resource_id = try(var.vault["0"].id, null)
      subresource_names              = try(private_service_connection.value["subresource_names"], null)
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "res_private_dns_zone_virtual_network_links" {
  for_each              = { for k, v in var.private_dns_zone_virtual_network_links : k => v }
  name                  = try("private-dns-zone-link-bakvault${var.common.client}${var.common.application_id}", null)
  private_dns_zone_name = try(azurerm_private_dns_zone.res_private_dns_zones[each.value.private_dns_zone_name].name, null)
  # private_dns_zone_name = try(each.value.private_dns_zone_name, null)
  resource_group_name   = try(var.common.resource_group_name, null)
  virtual_network_id    = try(var.virtual_networks[each.value.virtual_network_id].id, null)
}

# resource "azurerm_backup_policy_vm_workload" "res_backup_policy_vm_workloads" {
#   for_each            = { for k, v in var.backup_policy_vm_workloads : k => v }
#   resource_group_name = try(var.common.resource_group_name, null)
#   workload_type       = try(each.value.workload_type, null)
#   name                = try(each.value.name, null)
#   recovery_vault_name = azurerm_recovery_services_vault.res_recovery_services_vaults["0"].name
#   dynamic "protection_policy" {
#     for_each = try(each.value.protection_policy, [])
#     content {
#       policy_type = try(protection_policy.value["policy_type"], null)
#       dynamic "backup" {
#         for_each = try(protection_policy.value["backup"], []) == [] ? [] : [1]
#         content {
#           frequency_in_minutes = try(protection_policy.value.backup.frequency_in_minutes, null)
#           time                 = try(protection_policy.value.backup.time, null)
#           frequency            = try(protection_policy.value.backup.frequency, null)
#         }
#       }
#       dynamic "simple_retention" {
#         for_each = try(protection_policy.value["simple_retention"], []) == [] ? [] : [1]
#         content {
#           count = try(protection_policy.value.simple_retention.count, null)
#         }
#       }
#       dynamic "retention_daily" {
#         for_each = try(protection_policy.value["retention_daily"], []) == [] ? [] : [1]
#         content {
#           count = try(protection_policy.value.retention_daily.count, null)
#         }
#       }
#     }
#   }
#   dynamic "settings" {
#     for_each = try(each.value.settings, [])
#     content {
#       time_zone = try(settings.value["time_zone"], null)
#     }
#   }
# }



