###
### commands we'll be using later
###


CAT ?= cat
CHMOD ?= chmod
FIND ?= find
PACKER ?= packer
PYTHON ?= python
RM ?= rm
TERRAFORM ?= terraform.io


###
### variables
###


## file locations

# the Packer config file
packerfile ?= packer.json

# executable for testing
executable ?= verify_temperature.py

## build variables

# the region where we'll be working
region ?= us-east-1

# the EC2 instance type 
instance_type ?= t2.micro

# the source (base) AMI upon which to build (AMZN)
source_ami ?= ami-0ff8a91507f77f867

# the username Packer should use to connect to the instance
aws_ssh_username ?= ec2-user

# where the boot disk is attached
device_name ?= /dev/xvda

# the size of the boot disk (in GB)
volume_size ?= 10

# the name of the AMI to produce
ami_name ?= flexioncodechallenge

# the port that will be serving traffic
port ?= 80

# where the application will live
application_location = /application/

# the serving environment for the application
environment ?= development

# the name of the application
application ?= fcc

# the S3 bucket where we'll store remote state (THIS NEEDS TO EXIST FIRST)
remote-state-bucket ?= com.kdaweb.terraform-remote-state

# the domainname / Route53 zone to use (THIS NEEDS TO EXIST FIRST)
domain ?= kdaweb.com

# the hostname to use
hostname ?= $(application)

# the current owner of the produced AMI
owner ?= 688772714249

# security group we'll be using
sgs ?= sg-00fbabd161fd1dc5f

###
### runtime flags for Packer
###


ifeq ($(debug), true)
  debug_flag ?= -debug
else
  debug_flag =
endif

ifeq ($(verbose), true)
  verbose_flag ?= PACKER_LOG=1
else
  verbose_flag =
endif


###
### targets for make
###


# all is used to... make all the things
all: test ami live

# clean cleans up temporary files
clean:
	$(FIND) . \( \
     -name "*~" \
  -o -name "*.tmp" \
  -o -name "tmp.*" \
  -o -name "*.ymle" \
  -o -name "*.tfe" \
  -o -name "*.jsone" \
  -o -name site.retry \
  -o -name "build.*" \
  -o -name "*.crt" \
  -o -name "*.key" \
  -o -name "*.pem" \
  -o -name "*.pub" \
  -o -name hosts \
  -o -name "*.password" \
  -o -name "packer-provisioner-ansible*" \
\) -delete ; \
	$(RM) -f "$(account_filename)" \
	"$(access_key_filename)" \
	"$(secret_key_filename)" \
	; exit 0

# test runs unit tests
test:
	$(PYTHON) $(executable)

# ami builds the AMI using Packer
ami:
	access_key="$(AWS_ACCESS_KEY_ID)" \
	secret_key="$(AWS_SECRET_ACCESS_KEY)" \
	region="$(region)" \
	instance_type="$(instance_type)" \
	source_ami="$(source_ami)" \
	aws_ssh_username="$(aws_ssh_username)" \
	device_name="$(device_name)" \
	volume_size="$(volume_size)" \
	ami_name="$(ami_name)" \
	platform="amazon-ebs" \
	extravars="$(extravars)" \
	port="$(port)" \
	environment="$(environment)" \
	application_location="$(application_location)" \
	packer build $(debug_flag) $(verbose_flag) --only=amazon-ebs $(packerfile)

# live instantiates the AMI as an EC2 instance using Terraform
live:
	$(TERRAFORM) init && \
	$(TERRAFORM) plan -out=tfplan -input=false \
	-var port=$(port) \
	-var ami_name=$(ami_name) \
	-var region=$(region) \
	-var application_location=$(application_location) \
	-var environment=$(environment) \
	-var application=$(application) \
	-var remote-state-bucket=$(remote-state-bucket) \
	-var domain=$(domain) \
	-var hostname=$(hostname) \
	-var owner=$(owner) \
	-var sgs=$(sgs) \
	-var instance_type=$(instance_type) && \
	$(TERRAFORM) apply -input=false tfplan
