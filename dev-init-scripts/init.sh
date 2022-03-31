#! /bin/bash

# Used to update, setup user, password, and env.
# Replace KEY_NAME_HERE with the aws gen pem key
# Replace USER_NAME_HERE with the desired username
# Replace PASSWORD_HERE with the desired password
# Replace GITHUB_PAT with the desired github pat with access to make keys
# Replace GITHUB_USERNAME with github username
# Replace GITHUB_EMAIL with github email

HOST=$1

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo apt-get update'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo useradd --shell /bin/bash -m -p $(openssl passwd -crypt PASSWORD_HERE) USER_NAME_HERE'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo usermod -aG sudo USER_NAME_HERE'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo service sshd restart'

# Packages
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" "sudo apt-get -y install software-properties-common apt-transport-https ca-certificates curl gnupg lsb-release unzip jq"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" "sudo apt-get update"

# Setting up Github SSH
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'export ID=$(curl -s -u "GITHUB_USERNAME:GITHUB_PAT" -X GET https://api.github.com/user/keys | jq -r '\''.[0].id'\''); [ ! -z "${ID}" ] && [ "${ID}" != null ] && curl -u "GITHUB_USERNAME:GITHUB_PAT" -X DELETE https://api.github.com/user/keys/$ID'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo ssh-keygen -t ed25519 -C "github_email" -N "PASSWORD_HERE" <<< "/root/.ssh/id_ed25519" >/dev/null 2>&1'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'export PUB=$(sudo cat /root/.ssh/id_ed25519.pub); curl -u "GITHUB_USERNAME:GITHUB_PAT" -X POST -d "{\"key\":\"$PUB\"}" https://api.github.com/user/keys'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo mkdir -p /home/USER_NAME_HERE/.ssh; sudo cp /root/.ssh/id_ed25519 /home/USER_NAME_HERE/.ssh/id_ed25519; sudo cp /root/.ssh/id_ed25519.pub /home/USER_NAME_HERE/.ssh/id_ed25519.pub'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo chown USER_NAME_HERE /home/USER_NAME_HERE/.ssh; sudo chown USER_NAME_HERE /home/USER_NAME_HERE/.ssh/id_ed25519; sudo chown USER_NAME_HERE /home/USER_NAME_HERE/.ssh/id_ed25519.pub'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo chmod u+rwx /home/USER_NAME_HERE/.ssh; sudo chmod u+rwx /home/USER_NAME_HERE/.ssh/id_ed25519; sudo chmod u+rwx /home/USER_NAME_HERE/.ssh/id_ed25519.pub'

# Go
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" "wget https://go.dev/dl/go1.18.linux-amd64.tar.gz"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" "sudo tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" "sudo rm -rf go1.18.linux-amd64.tar.gz"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo sh -c '\''echo "export PATH=$PATH:/usr/local/go/bin" >> /home/USER_NAME_HERE/.profile'\'''

# Docker
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo apt-get update'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo apt-get -y install docker-ce docker-ce-cli containerd.io'

# Dotnet
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo dpkg -i packages-microsoft-prod.deb'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'rm packages-microsoft-prod.deb'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo apt-get update'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo apt-get install -y dotnet-sdk-6.0'

# Node
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo apt-get install -y nodejs'

# Terraform
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo apt-get update && sudo apt-get install terraform'

# AWS CLI
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'unzip awscliv2.zip'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "KEY_NAME_HERE" "ubuntu@${HOST}" 'sudo ./aws/install'
