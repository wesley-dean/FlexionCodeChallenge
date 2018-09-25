CAT ?= cat
CHMOD ?= chmod
FIND ?= find
PACKER ?= packer
RM ?= rm
TERRAFORM ?= terraform.io

packerfile ?= packer.json

region ?= us-east-1
instance_type ?= t2.micro
source_ami ?= ami-0ff8a91507f77f867
aws_ssh_username ?= ec2-user
device_name ?= /dev/xvda
volume_size ?= 10
ami_name ?= flexioncodechallenge

port ?= 80

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


all: ami image

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
	packer build $(debug_flag) $(verbose_flag) --only=amazon-ebs $(packerfile)

live:
	$(TERRAFORM) init &&
	$(TERRAFORM) plan -out=tfplan -input=false \
	-var port=$(port) && \
	$(TERRAFORM) apply -input=false tfplan
