system = "terraexample"
location = "westus"
azuread_service_principal_id = "487753ef-8cf6-4960-ad5f-9ceb7b82fcd7"
client_id = "487753ef-8cf6-4960-ad5f-9ceb7b82fcd7"
client_secret = "BamXJxkjC.O9ZBmL90P.obpA_7MLmf0V8-" 

comp_env = {
    development = "dev"
    uat = "uat"
    production = "prod"
}

vnet_cidr_range = {
  development = "30.0.0.0/16"
  uat = "30.0.0.0/16"
  production = "30.0.0.0/16"
  c1 = "30.0.0.0/16"
}

/* subnet_prefixes = {
    development = "30.0.0.0/21,30.0.30.0/28"
    uat = "30.0.0.0/21,30.0.30.0/28"
    production = "30.0.0.0/21,30.0.30.0/28"
}

subnet_names = {
    development = "snet-aks-dev-westus-001,snet-jenkins-dev-westus-001"
    uat = "snet-aks-uat-westus-001,snet-jenkins-uat-westus-001"
    production = "snet-aks-prod-westus-001,snet-jenkins-prod-westus-001"
}*/


aks_subnet_prefixes =  { 

    development = "30.0.0.0/21"
    uat = "30.0.0.0/21"
    production = "30.0.0.0/21"
     
}

jenkins_subnet_prefixes = { 
    development = "30.0.30.0/28"
    uat = "30.0.30.0/28"
    production = "30.0.30.0/28"
}

     

jenkins_subnet_names = {
    development = "snet-jenkins-dev-westus-001"
    uat = "snet-jenkins-uat-westus-001"
    production = "snet-jenkins-prod-westus-001"
}
     

aks_subnet_names = {
    development = "snet-aks-dev-westus-001"
    uat = "snet-aks-uat-westus-001"
    production = "snet-aks-prod-westus-001"
}

agent_count = {
 development = 1
 uat = 3
 production = 3
}

vmsize = {
 development = "Standard_B2s"
 uat = "Standard_DS1_v2"
 production = "Standard_DS1_v2"
}
