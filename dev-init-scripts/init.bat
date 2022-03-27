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