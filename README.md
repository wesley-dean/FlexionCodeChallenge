# FlexionCodeChallenge

This is Wes Dean's response to the Flexion Code Challenge.

## Overview
The application provides a web interface that allows the user
to submit values per the provided scenarios; the scenarios
include columns for "Input Temperature", "Target Units", and
"Student Response".  The scenarios also provide a column for
"Output" which has possible values of, "correct", "incorrect",
and "invalid".

Therefore, the application requests the three aforementioned
fields and responds with one of the aforementioned responses.

## Implementation
The application was written in Python using the Flask microframework;
the application is served by the Flask development webserver.

The repository includes a .travis.yml file that configures the
Travis CI service to stand-up a test environment and run the
unit tests provided.  If the unit tests pass, Travis CI will
then build an AMI using Packer and Ansible.  If the AMI
builds properly, Terraform is used to deploy the application
on an EC2 instance.

#### Tools required for manual build
* GNU Make (v4.1)
* Packer (v1.2.0)
* Terraform (v0.11.8)
* Ansible (v2.6.3)
* Python (tested with 2.7.15rc1)

### Stage 1: Test
Unit tests are provided that run the provides scenarios' data
and verify that the expected Outputs are returned.  The
Python 'UnitTest' framework is used to run the tests.

#### Manual execution
make test

### Stage 2: Build
An AMI is built using Packer; this AMI can be used to back / 
instantiate an AWS EC2 instance.  The individual build steps
are run by an Ansible playbook.  Amazon Linux is used as the
base / source AMI.

#### Manual execution
make ami

### Stage 3: Deploy
Once an AMI is built, it can be deployed using Terraform.  The
Terraform plan process uses an S3 bucket to store remote state;
this bucket needs to exist before running Terraform (it isn't
configured to create it).

Terraform will query AWS to find the AMI with the provided name
and owned by the provided owner.  This AMI will be used to back
a single AWS EC2 instance.

A security group is created that allows access to the application
via web interface.  By default, this is port 80.

#### Manual execution
make live

### Stage 4: Cleanup
To tear-down the application, use 'terraform destroy'

## Live Demo
To check out the application running on AWS, go to:

http://fcc.kdaweb.com/

## CI/CD Automation
Travis CI is used configured to receive a webhook from Github when
a commit is pushed to the repository's origin.  This kicks off
tasks to test, build, and deploy the application.