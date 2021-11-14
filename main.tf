resource "null_resource" "copy_execute" {

  connection {
    type        = "ssh"
    host        = var.ipAddress
    user        = var.userName
    password    = var.password
  }

# Make sure that the .ssh directory exists in your server's user account home folder
# ssh username@domain1@contoso.com mkdir C:\Users\username\.ssh\
  provisioner "remote-exec" {
    inline = [
      "New-Item C:\\Users\\${var.userName}\\.ssh\\ -Type Directory",
    ]
  }

# Use scp to copy the public key file generated previously on your client to the authorized_keys file on your server
# scp C:\Users\username\.ssh\id_ed25519.pub user1@domain1@contoso.com:C:\Users\username\.ssh\authorized_keys
    provisioner "file" {
    source      = "~/.ssh/ServerKey.pub"
    destination = "C:\\Users\\${var.userName}\\.ssh\\authorized_keys"
  }

}