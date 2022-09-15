sudo apt-get install wget unzip -y
sudo apt-get install file
wget https://releases.hashicorp.com/terraform/1.2.2/terraform_1.2.2_linux_amd64.zip
unzip terraform_1.2.2_linux_amd64.zip
ls -a
chmod +x terraform
file terraform
uname -a
sudo mv terraform /usr/local/bin
# cd terraform
# terraform -v