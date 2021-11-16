resource "null_resource" "copy_execute" {

  provisioner "file" {
  connection {
    timeout     = "2m"
    type        = "winrm"
    host        = var.ipAddress
    user        = var.userName
    password    = var.password
    insecure    = true
    port        = 5985

  }
    source      = "~/.ssh/ServerKey.pub"
    destination = "C:\\Users\\Administrator\\.ssh\\authorized_keys"
  	}

}