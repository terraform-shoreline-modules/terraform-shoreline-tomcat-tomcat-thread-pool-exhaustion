terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "tomcat_thread_pool_exhaustion" {
  source    = "./modules/tomcat_thread_pool_exhaustion"

  providers = {
    shoreline = shoreline
  }
}