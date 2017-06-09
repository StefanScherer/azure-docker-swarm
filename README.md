# Azure

Build a cross-platform Linux and Windows Docker Swarm in Azure with Terraform.

## Install Terraform
```
brew install terraform
```

## Secrets

Get your Azure ID's and secret with `pass`

```
eval $(pass azure-terraform)
```

You will need these environment variables for terraform

```
export ARM_SUBSCRIPTION_ID="uuid"
export ARM_CLIENT_ID="uuid"
export ARM_CLIENT_SECRET="secret"
export ARM_TENANT_ID="uuid"
```

## Configure

Adjust the file `variables.tf` to your needs to choose

- location / region
- DNS prefix and suffix
- size of the VM's, default is `Standard_D2_v2`
- username and password

## Plan

```bash
terraform plan
```

## Create / Apply

```bash
terraform apply
```

If you want multiple machines, increase the count of the workers

```
terraform apply -var 'count={ windows_workers=2 linux_workers=2 }' -var dns_prefix=mix -var account=mix -var admin_username=$USER -var admin_password=Passw0rd1234
```

Notice: Changing the count afterwards doesn't seem to work with Azure. So be sure to create the resource group with the correct count initially.

## Create the Docker Swarm

At the moment you have to create the Docker Swarm manually.

Log into the first Linux node with ssh and run

```
docker swarm init
```

Copy the output of the join command and log into the Windows node with RDP and
open a PowerShell terminal and paste the command

```
docker swarm join --token ...
```

## Start Portainer

Run Portainer on the manager node.

```
docker service create \
--name portainer \
--publish 9000:9000 \
--constraint 'node.role == manager' \
--mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
portainer/portainer \
-H unix:///var/run/docker.sock
```

Then open a browser and configure the admin password for Portainer UI.

```
open http://ads-lin-01.westeurope.cloudapp.azure.com
```

## Destroy

```bash
terraform destroy
```
