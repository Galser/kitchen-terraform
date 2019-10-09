# kitchen-terraform
Tutorial -  setting up a Terraform config to spin up an Amazon Web Services (AWS) EC2 instance using Inspec and Kitchen-Terraform from scratch.

# Purpose
This tutorial will walk you through setting up a Terraform config to spin up an Amazon Web Services (AWS) EC2 instance using Inspec and Kitchen-Terraform from scratch.

(Note: these instructions are for Unix based systems only)

# Notes

Original Tutorial is here : https://newcontext-oss.github.io/kitchen-terraform/tutorials/amazon_provider_ec2.html

Changes in this repo, that differs from original tutorial :
I've used `rbenv` to work with local version of Ruby 2.3.1 as current version in macOS Mojave is 2.6.4
That's why there is .ruby-version file in repo :


# To do
- [ ] Update README with changes for current version of Kitchen

# Done
- [x] initial readme
- [x] Prerequisites
- [x] Setup development environment
- [x] Setup Test Kitchen
- [x] Writing a test


# Run logs 

## Converge
```
-----> Starting Kitchen (v1.25.0)
-----> Creating <default-ubuntu>...
       Terraform v0.12.9
       + provider.aws v2.31.0
$$$$$$ Running command `terraform init -input=false -lock=true -lock-timeout=0s  -upgrade -force-copy -backend=true  -get=true -get-plugins=true -verify-plugins=true` in directory /Users/andrii/labs/skills/kitchen-terraform
       
       Initializing the backend...
       
       Initializing provider plugins...
       - Checking for available provider plugins...
       - Downloading plugin for provider "aws" (hashicorp/aws) 2.31.0...
       
       The following providers do not have any version constraints in configuration,
       so the latest version was installed.
       
       To prevent automatic upgrades to new major versions that may contain breaking
       changes, it is recommended to add version = "..." constraints to the
       corresponding provider blocks in configuration, with the constraint strings
       suggested below.
       
       * provider.aws: version = "~> 2.31"
       
       Terraform has been successfully initialized!
$$$$$$ Running command `terraform workspace select kitchen-terraform-default-ubuntu` in directory /Users/andrii/labs/skills/kitchen-terraform
       
       Workspace "kitchen-terraform-default-ubuntu" doesn't exist.
       
       You can create this workspace with the "new" subcommand.
$$$$$$ Running command `terraform workspace new kitchen-terraform-default-ubuntu` in directory /Users/andrii/labs/skills/kitchen-terraform
       Created and switched to workspace "kitchen-terraform-default-ubuntu"!
       
       You're now on a new, empty workspace. Workspaces isolate their state,
       so if you run "terraform plan" Terraform will not see any existing state
       for this configuration.
       Finished creating <default-ubuntu> (0m7.41s).
-----> Converging <default-ubuntu>...
       Terraform v0.12.9
       + provider.aws v2.31.0
$$$$$$ Running command `terraform workspace select kitchen-terraform-default-ubuntu` in directory /Users/andrii/labs/skills/kitchen-terraform
$$$$$$ Running command `terraform get -update` in directory /Users/andrii/labs/skills/kitchen-terraform
$$$$$$ Running command `terraform validate   -var-file="/Users/andrii/labs/skills/kitchen-terraform/testing.tfvars"` in directory /Users/andrii/labs/skills/kitchen-terraform
       Success! The configuration is valid.
       
$$$$$$ Running command `terraform apply -lock=true -lock-timeout=0s -input=false -auto-approve=true  -parallelism=10 -refresh=true  -var-file="/Users/andrii/labs/skills/kitchen-terraform/testing.tfvars"` in directory /Users/andrii/labs/skills/kitchen-terraform
       aws_key_pair.tf200-kitchen-test: Creating...
       aws_instance.example: Creating...
       aws_key_pair.tf200-kitchen-test: Creation complete after 0s [id=tf200-kitchen-test]
       aws_instance.example: Still creating... [10s elapsed]
       aws_instance.example: Still creating... [20s elapsed]
       aws_instance.example: Creation complete after 22s [id=i-0daf534b8c31a7fa0]
       
       Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
       
       Outputs:
       
       public_dns = ec2-35-156-75-243.eu-central-1.compute.amazonaws.com
       Finished converging <default-ubuntu> (0m29.06s).
-----> Kitchen is finished. (0m38.18s)
```

## Verify

### With TEST PASSING
Successful tests run : 
`bundle exec kitchen verify`
Output :
```
-----> Starting Kitchen (v1.25.0)
-----> Setting up <default-ubuntu>...
       Finished setting up <default-ubuntu> (0m0.00s).
-----> Verifying <default-ubuntu>...
$$$$$$ Running command `terraform workspace select kitchen-terraform-default-ubuntu` in directory /Users/andrii/labs/skills/kitchen-terraform
$$$$$$ Running command `terraform output -json` in directory /Users/andrii/labs/skills/kitchen-terraform
       [SSH] connection failed, retrying in 1 seconds (#<Errno::ECONNREFUSED: Connection refused - connect(2) for 35.156.75.243:22>)
default: Verifying host ec2-35-156-75-243.eu-central-1.compute.amazonaws.com

Profile: default
Version: (not specified)
Target:  ssh://ubuntu@ec2-35-156-75-243.eu-central-1.compute.amazonaws.com:22

  ✔  operating_system: Command: `lsb_release -a`
     ✔  Command: `lsb_release -a` stdout is expected to match /Ubuntu/


Profile Summary: 1 successful control, 0 control failures, 0 controls skipped
Test Summary: 1 successful, 0 failures, 0 skipped
       Finished verifying <default-ubuntu> (0m5.82s).
-----> Kitchen is finished. (0m7.53s)
```

### With TEST FAILING (2 reasons)
Replaced AMI to `ami-0c478807c46ad3bcf` (Amazon Linux), have redeployed all and run tests 
( destroy, converge, verify  ) :
```
bundle exec kitchen destroy
bundle exec kitchen converge
bundle exec kitchen verify
```
Output : 
```
bundle exec kitchen verify  
-----> Starting Kitchen (v1.25.0)
-----> Setting up <default-ubuntu>...
       Finished setting up <default-ubuntu> (0m0.00s).
-----> Verifying <default-ubuntu>...
$$$$$$ Running command `terraform workspace select kitchen-terraform-default-ubuntu` in directory /Users/andrii/labs/skills/kitchen-terraform
$$$$$$ Running command `terraform output -json` in directory /Users/andrii/labs/skills/kitchen-terraform
       [SSH] connection failed, retrying in 1 seconds (#<Net::SSH::AuthenticationFailed: Authentication failed for user ubuntu@ec2-3-123-24-240.eu-central-1.compute.amazonaws.com>)
       [SSH] connection failed, retrying in 1 seconds (#<Net::SSH::AuthenticationFailed: Authentication failed for user ubuntu@ec2-3-123-24-240.eu-central-1.compute.amazonaws.com>)
       [SSH] connection failed, retrying in 1 seconds (#<Net::SSH::AuthenticationFailed: Authentication failed for user ubuntu@ec2-3-123-24-240.eu-central-1.compute.amazonaws.com>)
       [SSH] connection failed, retrying in 1 seconds (#<Net::SSH::AuthenticationFailed: Authentication failed for user ubuntu@ec2-3-123-24-240.eu-central-1.compute.amazonaws.com>)
$$$$$$ [SSH] connection failed, terminating (#<Net::SSH::AuthenticationFailed: Authentication failed for user ubuntu@ec2-3-123-24-240.eu-central-1.compute.amazonaws.com>)
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: 1 actions failed.
>>>>>>     Verify failed on instance <default-ubuntu>.  Please see .kitchen/logs/default-ubuntu.log for more details
>>>>>> ----------------------
>>>>>> Please see .kitchen/logs/kitchen.log for more details
>>>>>> Also try running `kitchen diagnose --all` for configuration
```
Log contains error :
```
E, [2019-10-09T11:18:39.608452 #28982] ERROR -- default-ubuntu: ----End Backtrace-----
E, [2019-10-09T11:18:39.608470 #28982] ERROR -- default-ubuntu: ---Nested Exception---
E, [2019-10-09T11:18:39.608488 #28982] ERROR -- default-ubuntu: Class: Kitchen::Terraform::Error
E, [2019-10-09T11:18:39.608518 #28982] ERROR -- default-ubuntu: Message: default: Transport error, can't connect to 'ssh' backend: SSH session could not be established
E, [2019-10-09T11:18:39.608551 #28982] ERROR -- default-ubuntu: ----------------------
```
Sure, because the username we have specified for our test is ubuntu - this is fine for an ubuntu instance, but for an Amazon Linux instance, we need to use the ec2-user username
Replacing it in verifier : 
```ruby
verifier:
  name: terraform
  systems:
    - name: default
      backend: ssh
      key_files: 
        - ~/.ssh/id_rsa
      hosts_output: public_dns
      user: ec2-user
```
And running verify once more : 
```
 bundle exec kitchen verify
-----> Starting Kitchen (v1.25.0)
-----> Verifying <default-ubuntu>...
$$$$$$ Running command `terraform workspace select kitchen-terraform-default-ubuntu` in directory /Users/andrii/labs/skills/kitchen-terraform
$$$$$$ Running command `terraform output -json` in directory /Users/andrii/labs/skills/kitchen-terraform
default: Verifying host ec2-3-123-24-240.eu-central-1.compute.amazonaws.com

Profile: default
Version: (not specified)
Target:  ssh://ec2-user@ec2-3-123-24-240.eu-central-1.compute.amazonaws.com:22

  ×  operating_system: Command: `lsb_release -a`
     ×  Command: `lsb_release -a` stdout is expected to match /Ubuntu/
     expected "" to match /Ubuntu/
     Diff:
     @@ -1,2 +1,2 @@
     -/Ubuntu/
     +""



Profile Summary: 0 successful controls, 1 control failure, 0 controls skipped
Test Summary: 0 successful, 1 failure, 0 skipped
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: 1 actions failed.
>>>>>>     Verify failed on instance <default-ubuntu>.  Please see .kitchen/logs/default-ubuntu.log for more details
>>>>>> ----------------------
>>>>>> Please see .kitchen/logs/kitchen.log for more details
>>>>>> Also try running `kitchen diagnose --all` for configuration
```
So, now we see tes failure : 
```
×  operating_system: Command: `lsb_release -a`
     ×  Command: `lsb_release -a` stdout is expected to match /Ubuntu/
     expected "" to match /Ubuntu/
     Diff:
     @@ -1,2 +1,2 @@
     -/Ubuntu/
     +""
```
True, because we running now Amazon Linux, so that means our test is failing when it is supposed to be failing, and passing when it is supposed to pass.


## Destroy

```
bundle exec kitchen destroy
-----> Starting Kitchen (v1.25.0)
-----> Destroying <default-ubuntu>...
       Terraform v0.12.9
       + provider.aws v2.31.0
$$$$$$ Running command `terraform init -input=false -lock=true -lock-timeout=0s  -force-copy -backend=true  -get=true -get-plugins=true -verify-plugins=true` in directory /Users/andrii/labs/skills/kitchen-terraform
       
       Initializing the backend...
       
       Initializing provider plugins...
       
       The following providers do not have any version constraints in configuration,
       so the latest version was installed.
       
       To prevent automatic upgrades to new major versions that may contain breaking
       changes, it is recommended to add version = "..." constraints to the
       corresponding provider blocks in configuration, with the constraint strings
       suggested below.
       
       * provider.aws: version = "~> 2.31"
       
       Terraform has been successfully initialized!
$$$$$$ Running command `terraform workspace select kitchen-terraform-default-ubuntu` in directory /Users/andrii/labs/skills/kitchen-terraform
$$$$$$ Running command `terraform destroy -auto-approve -lock=true -lock-timeout=0s -input=false  -parallelism=10 -refresh=true  -var-file="/Users/andrii/labs/skills/kitchen-terraform/testing.tfvars"` in directory /Users/andrii/labs/skills/kitchen-terraform
       aws_key_pair.tf200-kitchen-test: Refreshing state... [id=tf200-kitchen-test]
       aws_instance.example: Refreshing state... [id=i-0daf534b8c31a7fa0]
       aws_key_pair.tf200-kitchen-test: Destroying... [id=tf200-kitchen-test]
       aws_instance.example: Destroying... [id=i-0daf534b8c31a7fa0]
       aws_key_pair.tf200-kitchen-test: Destruction complete after 0s
       aws_instance.example: Still destroying... [id=i-0daf534b8c31a7fa0, 10s elapsed]
       aws_instance.example: Still destroying... [id=i-0daf534b8c31a7fa0, 20s elapsed]
       aws_instance.example: Destruction complete after 30s
       
       Destroy complete! Resources: 2 destroyed.
$$$$$$ Running command `terraform workspace select default` in directory /Users/andrii/labs/skills/kitchen-terraform
       Switched to workspace "default".
$$$$$$ Running command `terraform workspace delete kitchen-terraform-default-ubuntu` in directory /Users/andrii/labs/skills/kitchen-terraform
       Deleted workspace "kitchen-terraform-default-ubuntu"!
       Finished destroying <default-ubuntu> (0m37.59s).
-----> Kitchen is finished. (0m39.40s)
```