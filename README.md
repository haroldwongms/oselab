# OpenShift Enterprise with Username / Password authentication for OpenShift

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fharoldwongms%2Foselab%2Fmaster%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fharoldwongms%2Foselab%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template deploys OpenShift Enterprise with basic username / password for authentication to OpenShift. It includes the following resources:

|Resource           |Properties                                                                                                                          |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------|
|Virtual Network    |**Address prefix:** 192.168.0.0/16<br />**Master subnet:** 192.168.1.0/24<br />**Node subnet:** 192.168.2.0/24                               |
|Load Balancer      |2 probes and two rules for TCP 80 and TCP 443 <br/> NAT rules for SSH on Ports 2200-220X                                                                                  |
|Public IP Addresses|OpenShift Master public IP<br />OpenShift Router public IP attached to Load Balancer                                                |
|Storage Accounts   |2 Storage Accounts                                                                                                                  |
|Virtual Machines   |Single master<br />User-defined number of nodes<br />All VMs include a single attached data disk for Docker thin pool logical volume|

## Prerequisites

### Generate SSH Keys

You'll need to generate a pair of SSH keys in order to provision this template. Ensure that you do not include a passcode with the private key. <br/>
If you are using a Windows computer, you can download puttygen.exe.  You will need to export to OpenSSH (from Conversions menu) to get a valid Private Key for use in the Template.<br/>
From a Linux or Mac, you can just use the ssh-keygen command.

### Create Key Vault to store SSH Private Key

You will need to create a Key Vault to store your SSH Private Key that will then be used as part of the deployment.

1. Create KeyVault using Powershell <br/>
  a.  Create new resource group: New-AzureRMResourceGroup -Name 'ResourceGroupName' -Location 'West US'<br/>
  b.  Create key vault: New-AzureRmKeyVault -VaultName 'KeyVaultName' -ResourceGroup 'ResourceGroupName' -Location 'West US'<br/>
  c.  Create variable with sshPrivateKey: $securesecret = ConvertTo-SecureString -String '[copy ssh Private Key here - including line feeds]' -AsPlainText -Force<br/>
  d.  Create Secret: Set-AzureKeyVaultSecret -Name 'SecretName' -SecretValue $securesecret -VaultName 'KeyVaultName'<br/>

2. Create Key Vault using Azure CLI - must be run from a Linux machine (can use Azure CLI container from Docker for Windows) or Mac<br/>
  a.  Create new Resource Group: azure group create \<name\> \<location\> <br/>
         Ex: [azure group create ResourceGroupName 'East US'] <br/>
  b.  Create Key Vault: azure keyvault create -u \<vault-name\> -g \<resource-group\> -l \<location\><br/>
         Ex: [azure keyvault create -u KeyVaultName -g ResourceGroupName -l 'East US'] <br/>
  c.  Create Secret: azure keyvault secret set -u \<vault-name\> -s \<secret-name\> --file \<File name of private key\><br/>
         Ex: [azure keyvault secret set -u KeyVaultName -s SecretName --file \<File name of private key\>] <br/>
  d.  Enable the Keyvvault for Template Deployment: azure keyvault set-policy -u \<vault-name\> --enabled-for-template-deployment true <br/>
         Ex: [azure keyvault set-policy -u KeyVaultName --enabled-for-template-deployment true] <br/>

### azuredeploy.Parameters.json File Explained

1.	_artifactsLocation: Artifacts URL for where template files are located
2.	masterVmSize: Select from one of the allowed VM sizes listed in the azuredeploy.json file
3.	nodeVmSize: Select from one of the allowed VM sizes listed in the azuredeploy.json file
4.	openshiftClusterPrefix: Cluster prefix used to generate Master and Node host names
5.	adminUsername: Admin username for OS login
6.	cloudAccessUsername: Your Cloud Access subscription user name
7.	cloudAccessPassword: The password for your Cloud Access subscription
8.	cloudAccessPoolId: The Pool ID that contains your RHEL and OpenShift subscriptions
9.	sshPublicKey: Copy your SSH Public Key here
10.	keyVaultResourceGroup: The name of the Resource Group that contains the Key Vault
11.	keyVaultName: The name of the Key Vault you created
12.	keyVaultSecret: The Secret Name you used when creating the Secret


## Deploy Template

Once you have collected all of the prerequisites for the template, you can deploy the template by clicking Deploy to Azure or populating the *azuredeploy.parameters.json* file and executing Resource Manager deployment commands with PowerShell or the xplat CLI.

### NOTE

The OpenShift Ansible playbook does take a while to run when using VMs backed by Standard Storage. VMs backed by Premium Storage are faster. If you want Premimum Storage, select a DS or GS series VM.
<hr />
Be sure to follow the OpenShift instructions to create the ncessary DNS entry for the OpenShift Router for access to applications.

### Additional OpenShift Configuration Options
 
You can configure additional settings per the official [OpenShift Enterprise Documentation](https://docs.openshift.com/enterprise/3.2/welcome/index.html).
