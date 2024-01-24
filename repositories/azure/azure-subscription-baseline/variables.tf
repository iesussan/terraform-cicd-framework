#========================resource group========================
variable "group_name" {}
variable "location" {}
variable "tags" {}
#========================log analytics workspace========================
variable "log_analytics_workspace_name" {}
variable "log_analytics_workspace_sku" {}
variable "log_analytics_workspace_retention_in_days" {}

#===================Azure EntrAID Groups Management===================
variable "users" {}
variable "application_code" {}


