# Prerequisites
Install following softwares.
- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Packer](https://www.packer.io/intro/getting-started/install.html#precompiled-binaries)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)


# Task 1
## Setup

### Create custom AMI with gitlab-runner installed
Create `env.json` file in the packer directory and give the values for variables as mentioned in the `env.json.tpl` template.

After Updating the env file, run the following command from `packer` directory to build the AMI.

```
packer build -var-file=env.json packer.json
```

After successful build of the AMI, go to the aws console and note the owner(it is id of the owner) of the AMI in ec2 section.

### Deploy resources to aws using terraform
Create `terraform.tfvars.json` file in the root directory of the project and give the values as mentioned in the `terraform.tfvars.json.tpl` template.

Create a key pair from the aws console and download the key. Store that key in the `~/.ssh/{Name of the key}`. Key pair can be created in ec2 section in as console.

```
{
	"access_key": "",  ## Access key of the aws IAM account
	"secret_key": "",  ## Secret key of the aws IAM account
	"default_region": "", ## Region in which the resources will be created
	"default_zone": "", ## Zone in which the resources will be created
	"key_name": "", ## Name of the key previously created which is used to ssh into the   instances.
	"no_of_runners": 2, ## Number of gitlab runners needed.
	"runner_ami_owner_id": "", ## Owner Id of the AMI previously created
	"gitlab_instance_url": "",  ## URL of the gitlab instance.
	"gitlab_runner_registration_token": "", ## Registration token used to connect the runners to gitlab instance.
	"gitlab_runner_executor": "shell" ## executor in which the tasks will be run. Keep it `shell`.
}

```
If we want a backend for terraform to store the terraform state in the cloud. Go to `backend.tf` file in the root directory and give the values to
- `bucket`. Give the name of the s3 bucket to store the state. The bucket has to be created in prior.
- `region`. Give the region of the s3 bucket.

If backend is not needed, remove the `backend.tf` file.

Run the following commands to deploy the resources to aws
```
terraform init
```
```
terraform plan
```
```
terraform apply
```

# Task 2

Go to `task2` folder.
Edit the `inventory.ini` file as mentioned below.
```
[bastion_host]
bastion anisble_host=3.15.10.41 ## External IP of the basation host. You can get the IP from aws console in instances section.

[runners]
10.0.2.143 ## Private IPs of k8s nodes.
10.0.2.45
```

Edit the `ssh.cfg` to give the External IP of the bastion host to route the ssh traffic through bastion server and key to connect to the instances via SSH.
```
Host bastion
  Hostname               3.15.10.41  ## Give the External IP of the Bastion host.
  User                   ubuntu
  ControlMaster          auto
  ControlPath           ~/.ssh/mux-%r@%h:%p
  ControlPersist         15m
  IdentityFile           ~/.ssh/{Name of the key} ## Path to the key previously installed on the local machine. 
  StrictHostKeyChecking  no

Host 10.0.2.*
  User                   ubuntu
  ProxyCommand           ssh -q -W %h:%p bastion
  IdentityFile           ~/.ssh/{Name of the key}  ## Path to the key previously installed on the local machine.
  StrictHostKeyChecking  no
```

After modifying the above files, run the following command to install the certificates on all nodes.

```
ansible-playbook -i inventory.ini playbook.yml
```

Note: The above config of task 2 is for one bastion host and multiple k8s nodes.


