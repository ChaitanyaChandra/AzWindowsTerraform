data "template_file" "setup_ps1" {
  template = file("${var.userdata}/${var.setup_ps1}")
}

resource "null_resource" "remote-exec-windows" {

  # WinRM connections via Terraform are going to fail if it is not configured correctly as mentioned in comment section above
  count = var.is_winrm_configured_for_image == "true" ? 1 : 0

  provisioner "file" {
    connection {
      type     = "winrm"
      agent    = false
      timeout  = "1m"
      host     = var.ipAddress
      user     = var.userName
      password = var.password
      port     = var.is_winrm_configured_for_ssl == "true" ? 5986 : 5985
      https    = var.is_winrm_configured_for_ssl
      insecure = "true" #self-signed certificate
    }

    content     = data.template_file.setup_ps1.rendered
    destination = "c:/temp/setup.ps1"
  }

  provisioner "remote-exec" {
    connection {
      type     = "winrm"
      agent    = false
      timeout  = "1m"
      host     = var.ipAddress
      user     = var.userName
      password = var.password
      port     = var.is_winrm_configured_for_ssl == "true" ? 5986 : 5985
      https    = var.is_winrm_configured_for_ssl
      insecure = "true" #self-signed certificate
    }

    inline = [
      "powershell.exe -file c:/temp/setup.ps1",
    ]
  }
}