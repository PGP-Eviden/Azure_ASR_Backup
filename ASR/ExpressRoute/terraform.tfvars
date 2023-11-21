// Automatically generated variables
// Should be changed
common = {
  "location" : "northeurope",
  "Location_short" : "eun",
  "client" : "client",
  "application_id" : "01",
  "location_azure" : "westeurope",
  "on_premises" : false
}

tags = {
  "Environment" : "pro",
  "confidentiality" : "private",
  "Criticalicity" : "2",
  "Lock" : "true",
  "Department" : "it",
  "ProductOwner" : "eniden",
  "CloudArchitect" : "nombre@eviden.com",
  "Developers" : "eviden",
  "Hyperscaler" : "azu"
}
// Start of the variables for the module ASR
recovery_services_vaults = [
  {
    #"name":"asrVault"
    "sku" : "RS0"
  }
]
backup_policy_vms = [
  {
    "backup" : [
      {
        "frequency" : "Daily",
        "time" : "17:30"
      }
    ],
    "name" : "DefaultPolicy",
    #"recovery_vault_name" : "VaultASR",
    "retention_daily" : [
      {
        "count" : 30
      }
    ]
  },
  {
    "backup" : [
      {
        "frequency" : "Hourly",
        "hour_duration" : 12,
        "hour_interval" : 4,
        "time" : "08:00"
      }
    ],
    "name" : "EnhancedPolicy",
    "policy_type" : "V2",
    #"recovery_vault_name" : "VaultASR",
    "retention_daily" : [
      {
        "count" : 30
      }
    ]
  }
]
backup_policy_vm_workloads = [
  {
    "name" : "HourlyLogBackup",
    "protection_policy" : [
      {
        "backup" : {
          "frequency_in_minutes" : 60
        },
        "policy_type" : "Log",
        "simple_retention" : {
          "count" : 30
        }
      },
      {
        "backup" : {
          "frequency" : "Daily",
          "time" : "17:30"
        },
        "policy_type" : "Full",
        "retention_daily" : {
          "count" : 30
        }
      }
    ],
    #"recovery_vault_name" : "VaultASR",
    "settings" : [
      {
        "time_zone" : "UTC"
      }
    ],
    "workload_type" : "SQLDataBase"
  }
]
storage_accounts = [
  {
    "account_replication_type" : "LRS",
    "account_tier" : "Standard",
    "resource_group_origin"    : "Prueba_monitor",
    "allow_nested_items_to_be_public" : false,
    "cross_tenant_replication_enabled" : false,
    #"name" : "almacenasr001",
  }
]
// End of the variables for the module ASR

// Start of the variables for the module ResourceGroup
resource_groups = [
  {
    #"name" : "ASR-Azure",
    "tags" : {
      "responsable" : "Cliente"
    }
  }
]
// End of the variables for the module ResourceGroup

// Start of the variables for the module Network
public_ips = [
  {
    "allocation_method" : "Static",
    #"name" : "VPNGW-ASR-PUBLICIP",
    #"resource_group_name" : "ASR-Azure",
    "sku" : "Standard"
  }
]
virtual_network_gateways = [
  {
    "ip_configuration" : [
      {
        "name" : "default",
        "public_ip_address_id" : "0" #"/subscriptions/0b6b4c37-f1bf-4ce2-a367-85ec50c803ea/resourceGroups/ASR-Azure/providers/Microsoft.Network/publicIPAddresses/ip-vpn-nwg-asrclient01",
        "subnet_id" : "0"
      }
    ],
    #"name" : "VPNGW-ASR",
    #"resource_group_name" : "ASR-Azure",
    "sku" : "VpnGw1",
    "type" : "Vpn"
  }
]
virtual_networks = [
  {
    "address_space" : [
      "10.0.0.0/16"
    ],
    #"name" : "Vnet-asr01",
    #"resource_group_name" : "ASR-Azure"
  }
]
subnets = [
  {
    "address_prefixes" : [
      "10.0.1.0/24"
    ],
    "name" : "GatewaySubnet",
    #"resource_group_name" : "ASR-Azure",
    #"virtual_network_name" : "Vnet-asr01"
  },
  {
    "address_prefixes" : [
      "10.0.0.0/24"
    ],
    #"name" : "Subnet-asr",
    #"resource_group_name" : "ASR-Azure",
    #"virtual_network_name" : "Vnet-asr01"
  }
]
// End of the variables for the module Network
