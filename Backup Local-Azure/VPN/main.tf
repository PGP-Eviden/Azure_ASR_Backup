terraform {
  backend "local" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.56.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

locals {
  #resource_group_name="rg-${var.common.Location_short}-bak${var.common.client}${var.common.application_id}"
  common = merge(var.common, { "resource_group_name" : "rg-${var.common.Location_short}-bak${var.common.client}${var.common.application_id}" })
  tags = merge(var.tags, {
    "Region" : var.common.location,
    "ApplicationID" : var.common.application_id
  })
}
module "ResourceGroup" {
  source          = "../Modules/ResourceGroup"
  common          = local.common
  tags            = local.tags
  resource_groups = var.resource_groups
}

module "Backup" {
  source                     = "../Modules/Backup"
  common                     = local.common
  tags                       = local.tags
  recovery_services_vaults   = var.recovery_services_vaults
  backup_policy_vms          = var.backup_policy_vms
  backup_policy_vm_workloads = var.backup_policy_vm_workloads
  private_dns_zones                      = var.private_dns_zones
  private_dns_a_records                  = var.private_dns_a_records
  private_dns_zone_virtual_network_links = var.private_dns_zone_virtual_network_links
  private_endpoints                      = var.private_endpoints
  subnets                                = module.Network.subnets
  virtual_networks                       = module.Network.virtual_networks
  depends_on                 = [module.ResourceGroup]
}



module "Network" {
  source           = "../Modules/Network"
  common           = local.common
  tags             = local.tags
  virtual_networks = var.virtual_networks
  subnets          = var.subnets
  depends_on       = [module.ResourceGroup]
}

module "VPNGateway" {
  source                                 = "../Modules/VPNGateway"
  common                                 = local.common
  tags                                   = local.tags
  public_ips                             = var.public_ips
  virtual_network_gateways               = var.virtual_network_gateways
  subnets                                = module.Network.subnets
  virtual_networks                       = module.Network.virtual_networks
  depends_on                             = [module.ResourceGroup]

}
