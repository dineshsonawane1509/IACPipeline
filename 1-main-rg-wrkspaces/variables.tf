variable "system" {
    type = string
    description = "Name of the system or environment"
}

variable "location" {
    type = string
    description = "Azure location of terraform server environment"
    default = "westus"
}

variable "azuread_service_principal_id" {
    type = string
    description = "Azure Service account of terraform File execution"
    default =  "6101397b-6b8d-4461-818a-ca7cef07ce8c"
}

variable "aksclustername" {
    type = string
    description = "Kubernetes cluster settings "
    default =  "aks-udxmaestro-prod-westus-001"
}

variable "client_id" { type = string }
variable "client_secret" { type = string}

variable "agent_count" {
  type = map(number)
}

variable "vmsize" {
  type = map(string)
}





variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}



variable "comp_env" {
    type = map(string)
}

variable "vnet_cidr_range" { 
     type = map(string)
}

variable "aks_subnet_prefixes" { 
     type = map(string)
}

variable "jenkins_subnet_prefixes" { 
     type = map(string)
}

variable "aks_subnet_names" { 
     type = map(string)
}

variable "jenkins_subnet_names" { 
     type = map(string)
}


##################################################################################
# LOCALS
##################################################################################

locals {
  env_name = lower(terraform.workspace)
  env_small = lower(var.comp_env[terraform.workspace])
  vnetciderblock = [var.vnet_cidr_range[terraform.workspace]]
  aksciderblock = [var.aks_subnet_prefixes[terraform.workspace]]
  jenkinsciderblock = [var.jenkins_subnet_prefixes[terraform.workspace]]
  
  common_tags = {
      Environment = local.env_name
  }

  acrname = "acr${local.env_small}${random_integer.rand.result}"
  

  
}





