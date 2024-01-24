variable "users" {
    description = "The list of users to add to the group"
    type    = list(string)
}

variable "application_code" {
  description = "The name of the application"
}