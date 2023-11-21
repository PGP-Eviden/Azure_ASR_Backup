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
  //public_network_access_enabled = each.value.public_network_access_enabled
  
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



