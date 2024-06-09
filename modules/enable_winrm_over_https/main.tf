# modules/enable_winrm_over_https/main.tf

resource "azurerm_virtual_machine_extension" "enable_winrm" {
  count                = length([for vm in var.vm_configs : vm if vm.enable_powershell_remoting])
  name                 = "${element([for vm in var.vm_configs : vm.name if vm.enable_powershell_remoting], count.index)}-enable-winrm"
  virtual_machine_id   = element(var.vm_ids, count.index)
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "fileUris": ["https://jonnybottles.blob.core.windows.net/scripts/enable_winrm_https_template.ps1?sp=r&st=2024-06-09T08:58:16Z&se=2029-04-01T16:58:16Z&spr=https&sv=2022-11-02&sr=b&sig=5%2BYqVoelau67YN%2BtR%2FkuUNV9Qs8f9bPNmBQwE7WmaVw%3D"],
      "commandToExecute": "powershell -ExecutionPolicy Bypass -Command \"Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force; ./enable_winrm_https_template.ps1 -PrivateIp ${element(var.vm_private_ips, count.index)} ${length(var.vm_public_ips) > count.index ? "-PublicIp ${element(var.vm_public_ips, count.index)}" : ""}\""
    }
  SETTINGS
}

#resource "null_resource" "check_winrm" {
#  count = length([for vm in var.vm_configs : vm if vm.enable_powershell_remoting])
#
#  connection {
#    type     = "winrm"
#    user     = var.admin_username
#    password = var.admin_password
#    host     = element(var.vm_private_ips, count.index)
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "if (Test-Path 'C:\\enable_winrm_https.log') { Get-Content 'C:\\enable_winrm_https.log' } else { exit 1 }"
#    ]
#  }
#
#  depends_on = [azurerm_virtual_machine_extension.enable_winrm]
#}
