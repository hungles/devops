########Variables#############

variable vm_size {
    description = "Tamaño de las Maquinas virtuales(Free Plan)"
    default = "Standard_B1s"
}

variable vm_password {
    description = "Sistema Operativo para las maquinas virtuales"
    default = "P@ssw0rd1234!"
}

variable region {
    description = "Region donde se desplegara los servicios"
    default = "eastus"
}

variable azure_subscription {
    description = "Subscripcion de Azure"
    default = ""
}
