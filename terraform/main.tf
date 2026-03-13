provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "house_price_pred"
  location = "Central India"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "devops-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "YOUR_IP/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "10.85.62.232"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "devops-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "devops-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "devops-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  name                = "devops-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "devops-vm"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwSRNGxGloDSW4q+NpVdWj+9Dzm9jqd1jqhzbXtTlXyCvbXevl+LXYRUO2efftH5z96y95WE6GbhRQvxrKsxxu/wHwFOTT+GZdf0ts5qcf4tZ5CV4vlC5ve8LTuBvHmm10AYfjblMY2dyQ9yiovhr4VchOZ8pUDWmrcYxiOvN1ghlC6q0oZjcMyZ9tv848Ybm1Leu/mQ89NRy9KLIaMdSx34t118tUx2HEAzohpXzVZ/STDFTu6R8frfFItiTf8Vb3LqZBo6AZPAjvxfDamP0AsSPaY8O5wx6pGLy8gIhEYi+B45zzwFeTeHUPKU01Hrss/fU63VDf+uJ2xil0AQgZrA9VBqWyyGvKvqkiw05JafbpjNsdhtBRPKA5btARnmDzZMeR/EcExgOFiHeBiPAliyL69Z6xtTx0PeoGJrXcECcdIvy81qXRWoGuNf4VaUqQqAvh+uQ5yG8PiTL6yJ4CjhfqEo6vYvoaT1qoYKMvJ38D93AH72bUo+l3Pyvwf/7qLOiO5f9Gpm68OC0ndPjQ+bghpGsw+YD/KOyr+gMeYCTqPH5U3OeABpWFxzM/8f7jRedhPfBTtI/fb4g15uIayVW1vQ/m6drBl2OqYi0u+bYzIpnHO+S6vjudvHXmX0v6Q/qosTvERdCEmVUqZvK1Mf/xXuvIpg3ai2rq2VX0uQ== hp@Sahu"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}