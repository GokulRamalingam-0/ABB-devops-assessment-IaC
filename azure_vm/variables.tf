variable "location" {
    type = string
    default = "West US"
}

variable "rg_name" {
    type = string
}

variable "admin_username" {
    type = string
    default = "ubuntu"
}

variable "admin_password" {
    type = string
    default = "Welcome@1432"
}

variable "vm_size" {
    type = string
    default = "Standard_D2s_v3"
}