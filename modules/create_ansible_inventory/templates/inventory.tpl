[windows]
%{ for name, info in vm_infos ~}
${info.ip} ansible_user=${ansible_user} ansible_password='${ansible_password}' ansible_port=5986 ansible_connection=winrm ansible_winrm_server_cert_validation=ignore
%{ endfor ~}

[all:vars]
ansible_python_interpreter=/usr/bin/python3

[all]
%{ for name, info in vm_infos ~}
${info.ip}
%{ endfor ~}

[dcs]
%{ for name, info in vm_infos ~}
%{ if info.is_dc ~}
${info.ip}
%{ endif ~}
%{ endfor ~}

[non_dcs]
%{ for name, info in vm_infos ~}
%{ if !info.is_dc ~}
${info.ip}
%{ endif ~}
%{ endfor ~}
