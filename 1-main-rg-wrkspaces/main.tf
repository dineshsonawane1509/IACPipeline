#############################################################################
# VARIABLES
#############################################################################

#variable "environment_name" {
#    type = string
#    default="Development"
#}


#############################################################################
# DATA
#############################################################################

  #data "azurerm_subscription" "current" {}
  #test = lookup(var.comp_env,var.environment_name) 
  #rgname = "rg-udxmaestro-${test}-${var.location}-001"

  

#############################################################################
# BACKENDS
#############################################################################
 


#############################################################################
# REMOTE BACKENDS
#############################################################################




#############################################################################
# PROVIDERS
#############################################################################
provider "azurerm" {
   version = "=2.10.0"
   subscription_id = "AZURE_SUBSCRIPTION_ID"
   tenant_id = "AZURE_TENANT_ID"
   client_id = "AZURE_CLIENT_ID"
   client_secret = "AZURE_CLIENT_SECRET"    
   features {}
}         


#############################################################################
# RESOURCES
#############################################################################

#variable "foo" {
#  type = "list"
#  default = [ 1,2,3 ]
#}

# assume a value of 4 of type number is the additional value to be appended
#resource "bar_type" "bar" {
#  bar_field = "${concat(var.foo, [4])}"
#}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}


resource "azurerm_resource_group" "rg" {
  name     = "rg-udxmaestro-${local.env_small}-${var.location}-001"
  location = var.location
  tags  = merge(local.common_tags, {Name = "${local.env_name}" })
}

resource "azurerm_virtual_network" "aksvnet" {
  name                = "vnet-${local.env_small}-${var.location}-001"
  address_space       = local.vnetciderblock
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snetaks" {
  name                 = var.aks_subnet_names[local.env_name]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  address_prefixes     = local.aksciderblock
  
}

resource "azurerm_subnet" "snetjenkins" {
  name                 = var.jenkins_subnet_names[local.env_name]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  address_prefixes     = local.jenkinsciderblock
}



 resource "azurerm_container_registry" "acr" {
  name                     = local.acrname
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  sku                      = "basic"
  admin_enabled            = true

}


resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = var.azuread_service_principal_id
  skip_service_principal_aad_check = true
}


resource "azurerm_role_assignment" "snetakscontributerole" {
  scope                            = azurerm_virtual_network.aksvnet.id
  role_definition_name             = "Contributor"
  principal_id                     = var.azuread_service_principal_id
  skip_service_principal_aad_check = true
}


resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "aks-udxmaestro-${local.env_small}-${var.location}-001"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    dns_prefix          = "udx"
    
    

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count[terraform.workspace]
        vm_size         = var.vmsize[terraform.workspace]
        type            = "VirtualMachineScaleSets"
        vnet_subnet_id = azurerm_subnet.snetaks.id
    }

    service_principal {
        client_id     = var.client_id
        client_secret = var.client_secret
    }

    tags = {
        Environment = terraform.workspace
    }

  network_profile {
          dns_service_ip     = "31.0.0.10"
          docker_bridge_cidr = "172.17.0.1/16"
          load_balancer_sku  = "standard"
          network_plugin     = "azure"
          network_policy     = "calico"
          #outbound_type      = (known after apply)
          #pod_cidr           = (known after apply)
          service_cidr       = "31.0.0.0/16"
        }

} 





#############################################################################
# Modules
#############################################################################

/* module "vnet-aks" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  #resource_group_name = azurerm_resource_group.aks.name
  vnet_name           = "vnet-${local.env_small}-${var.location}-001"
  address_space       = local.vnetciderblock
  subnet_prefixes     = split(",",var.subnet_prefixes[terraform.workspace]) 
  subnet_names        = split(",",var.subnet_names[terraform.workspace])
  nsg_ids             = {}

}*/

#############################################################################
# OUTPUTS
#############################################################################

 
#############################################################################
# PROVISIONERS
#############################################################################
