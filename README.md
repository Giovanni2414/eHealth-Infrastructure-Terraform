# eHealth-Infrastructure-Terraform
#### Here are the steps to put all on work each time you perform ```terraform apply``` :)
1. Change the host ip inside the INVENTORY in the ansible repository secrets: [Repository](https://github.com/Giovanni2414/eHealth-Ansible-Vm)
2. Perform github workflows in the previous repository to perform the Configuration Management with Ansible
3. Copy the kubeconfig to your machine to perform the ```deployment.yaml``` and ```service.yaml``` for the first time using ```kubectl```
