provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main-rg" {
  name     = "${var.basic-name}-rg"
  location = var.region
}

resource "azurerm_virtual_network" "main-vn" {
  name                = "${var.basic-name}-vn"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main-rg.location
  resource_group_name = azurerm_resource_group.main-rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.basic-name}-subnet"
  resource_group_name  = azurerm_resource_group.main-rg.name
  virtual_network_name = azurerm_virtual_network.main-vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.basic-name}-public-ip"
  location            = azurerm_resource_group.main-rg.location
  resource_group_name = azurerm_resource_group.main-rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "devops_nic" {
  name                = "${var.basic-name}-nic"
  location            = azurerm_resource_group.main-rg.location
  resource_group_name = azurerm_resource_group.main-rg.name

  ip_configuration {
    name                          = "${var.basic-name}-configuration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_security_group" "sg" {
  name                = "${var.basic-name}-sg"
  location            = azurerm_resource_group.main-rg.location
  resource_group_name = azurerm_resource_group.main-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Sonar"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_sg_association" {
  network_interface_id      = azurerm_network_interface.devops_nic.id
  network_security_group_id = azurerm_network_security_group.sg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "${var.basic-name}-machine"
  resource_group_name             = azurerm_resource_group.main-rg.name
  location                        = azurerm_resource_group.main-rg.location
  size                            = "Standard_DS1_v2"
  network_interface_ids           = [azurerm_network_interface.devops_nic.id, ]
  disable_password_authentication = false
  admin_username                  = "jenkinsSonar"
  admin_password                  = "Nike4545!"

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  depends_on = [azurerm_network_interface_security_group_association.nic_sg_association]
}

/*resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks1"
  location            = azurerm_resource_group.main-rg.location
  resource_group_name = azurerm_resource_group.main-rg.name
  dns_prefix          = "${var.prefix}-aks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

data "azurerm_kubernetes_cluster" "example" {
  name                = azurerm_kubernetes_cluster.aks.name
  resource_group_name = azurerm_resource_group.main-rg.name
}

resource "local_file" "foo" {
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = "${path.module}/kubeconfig"
}*/
