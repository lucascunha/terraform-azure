# Vamos agora criar um null resource para se conectar à VM e realizar uma ação
# instalar alguma coisa, por ex.
# Definimos que a conexão será via SSH, passamos usuário, senha e o nome do host

# Criando um null resource para instalar o servidor apache2 na VM
resource "null_resource" "install_webserver" {
  connection {
    type = "ssh"
    host = data.azurerm_public_ip.ip-aulainfra-data.ip_address
    user = var.user
    password = var.password
  }

  # executa um comando remoto
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y apache2",
    ]
  }

  # Para garantir que o null resource só será criado após a máqujna estar pronta
  depends_on = [
    azurerm_linux_virtual_machine.vm-aulainfra
  ]
}

# Novo null resource para subir minha aplicação na VM
resource "null_resource" "upload-app" {
  connection {
    type = "ssh"
    host = data.azurerm_public_ip.ip-aulainfra-data.ip_address
    user = var.user
    password = var.password
  }

  # faz upload de um arquivo
  provisioner "file" {
    source = "app"
    destination = "/home/adminuser"
  }

  depends_on = [
    azurerm_linux_virtual_machine.vm-aulainfra
  ]
}