:: Used to update, setup user, password, and env.
:: Replace KEY_NAME_HERE with the aws gen pem key
:: Replace USER_NAME_HERE with the desired username
:: Replace PASSWORD_HERE with the desired password

set HOST=%1

ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo apt-get update"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo useradd --shell /bin/bash -m -p $(openssl passwd -crypt PASSWORD_HERE) USER_NAME_HERE"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo usermod -aG sudo USER_NAME_HERE"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo sed -i ""/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes"" /etc/ssh/sshd_config"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo service sshd restart"

:: Setting up dev tools

:: Packages
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo apt-get -y install software-properties-common apt-transport-https ca-certificates curl gnupg lsb-release unzip"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo apt-get update"

:: Go
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "wget https://go.dev/dl/go1.18.linux-amd64.tar.gz"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo rm -rf go1.18.linux-amd64.tar.gz"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo sh -c 'echo ""export PATH=\$PATH:/usr/local/go/bin"" >> /home/shawn/.profile'"

:: Docker
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "echo ""deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo apt-get update"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo apt-get -y install docker-ce docker-ce-cli containerd.io"

:: Dotnet
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo dpkg -i packages-microsoft-prod.deb"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "rm packages-microsoft-prod.deb"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo apt-get update"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo apt-get install -y dotnet-sdk-6.0"

:: Node
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo apt-get install -y nodejs"

:: Terraform
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo apt-add-repository ""deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"""
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo apt-get update && sudo apt-get install terraform"

:: AWS CLI
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "curl ""https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"" -o ""awscliv2.zip""
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "unzip awscliv2.zip"
ssh -o StrictHostKeyChecking=no -i "KEY_NAME_HERE" ubuntu@%HOST% "sudo ./aws/install"
