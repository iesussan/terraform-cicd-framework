data "azuread_users" "this_users" {
    user_principal_names = var.users
}

data "azurerm_client_config" "current" {}

resource "azuread_group" "this_group" {
  display_name = "${var.application_code}-aks-users-administrators"
  security_enabled = true
}

resource "azuread_group_member" "this_member" {
  for_each = toset(data.azuread_users.this_users.users[*].object_id)
  group_object_id  = azuread_group.this_group.object_id
  member_object_id = each.value
}

##### Terraform  runtime user ################
data "azuread_service_principal" "this_terraform_runtime_user" {
  display_name = "devops-automation"
}
resource "azuread_group_member" "this_member_terraform" {
  group_object_id  = azuread_group.this_group.object_id
  member_object_id = data.azuread_service_principal.this_terraform_runtime_user.object_id
}

