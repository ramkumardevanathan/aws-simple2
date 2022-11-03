resource "aws_vpc" "vpcByTFE" {
  # id = "vpc-03d91b66"
  cidr_block  = "10.0.0.0/16"
}

resource "aws_subnet" "subnetByTFE" {
  vpc_id      = aws_vpc.vpcByTFE.id
  cidr_block  = "10.0.1.0/24"
}

resource "aws_network_interface" "nicByTFE" {
  subnet_id = aws_subnet.subnetByTFE.id
}

resource "aws_instance" "ec2ByTFEtest" {
  ami           = var.ami
  instance_type = var.instance_type
tags = {
    Name = "tf_server-ayush"
  }
 
  network_interface {
    network_interface_id = aws_network_interface.nicByTFE.id
    device_index         = 0
  }
}

variable "access_key" {}

variable "secret_key" {}

variable "region" {
  type  = string
  default = "us-east-1"
}

variable "ami" {
  type    = string
  default = "ami-0022c769"
}

variable "instance_type" {
  type    = string
  default = "c1.medium"
}

variable "lightstep_api_key" {
  type = string
  default = "j5adiiMzWn3vL3pntRXZaFnSnImSFdmu4VY+hxAp2nKSSStrGbLmGeyoLOOLR1Goc0ia1VHAGg9M1e6cQlfaiKcLhyN3JubCDK9m19Vq"
}

provider "aws" {
  access_key          = var.access_key
  secret_key          = var.secret_key
  region              = var.region
  version             = ">= 3.0"
}

terraform {
  required_providers {
    lightstep = {
      source  = "lightstep/lightstep"
      version = "~> 1.60.2"
    }
  }
  required_version = ">= v1.0.11"
}


module "aws-dashboards_example_ec2-dashboard" {
  source  = "lightstep/aws-dashboards/lightstep//examples/ec2-dashboard"
  version = "1.60.3"
  # insert the 2 required variables here
}

provider "lightstep" {
  api_key         = var.lightstep_api_key
  organization    = var.lightstep_organization
}

module "aws-dashboards" {
  source  = "lightstep/aws-dashboards/lightstep"
  version = "1.60.3"
  # insert the 2 required variables here
}

