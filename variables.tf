variable "resource_group_name" {
  default = "corp-datamiddlwre-platopt-kmj251-sb-001-rg"
}

variable "basic_tags" {
  type = object({
    CostCenter  = string
    DMZ         = string
    Department  = string
    Division    = string
    Environment = string
    ManagedBy   = string
    Owner       = string
    Program     = string
    Project     = string
  })
  description = "Default tags"
  default = {
    CostCenter  = "D100-84IM64"
    DMZ         = "No"
    Department  = "Cloud Platform"
    Division    = "Corp"
    Environment = "Sandbox"
    ManagedBy   = "Terraform"
    Owner       = "Kevin Jakubczak | kevin.m.jakubczak@sherwin.com"
    Program     = "Cloud Platform"
    Project     = "PPM 220086"
  }

}