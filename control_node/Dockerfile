# Use a base image with Python installed
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    curl \
    unzip \
    gnupg2 \
    software-properties-common \
    openssh-server \
    iproute2 \
    net-tools

# Install PowerShell
RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell

# Install Ansible
RUN apt-add-repository --yes --update ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible ssh

# Create ansible user and set up SSH
RUN useradd -m ansible && echo "ansible:password" | chpasswd && \
    mkdir -p /home/ansible/.ssh && chown -R ansible:ansible /home/ansible/.ssh

# Copy SSH keys
ARG SSH_KEY_PATH
COPY --chown=ansible:ansible ${SSH_KEY_PATH} /home/ansible/.ssh/authorized_keys
RUN chmod 600 /home/ansible/.ssh/authorized_keys

# Install Python packages for Ansible
RUN apt-get install -y python3-pip && \
    pip3 install pywinrm

# Copy Ansible playbook
COPY ansible/playbook.yml /home/ansible/playbook.yml
RUN chown ansible:ansible /home/ansible/playbook.yml

# Copy entry point script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose SSH port
EXPOSE 22

# Entry point to start the container
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
