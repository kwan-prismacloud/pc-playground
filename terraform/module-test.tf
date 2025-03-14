terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    yor_name  = "vpc"
    yor_trace = "03d687eb-029a-4453-af5c-77361e026527"
  }
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"
  count   = 2

  name = "kwan-ec2-instance-${count.index}"

  ami                    = "ami-0d0f28110d16ee7d6"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  associate_public_ip_address = true

  tags = {
    yor_name  = "ec2_instances"
    yor_trace = "4756b24e-060e-476b-be77-7f968a162b37"
  }
}

module "website_s3_bucket" {
  source        = "github.com/kwan-prismacloud/terraform-kwan-modules//aws-s3-static-website-bucket"
  bucket_prefix = var.static_website_s3_bucket_prefix
  tags = merge(var.static_website_s3_bucket_tags, {
    yor_name  = "website_s3_bucket"
    yor_trace = "9b9b4c0f-573a-480b-a07e-686bd2ec600f"
  })
}

module "example" {
  source  = "./modules/sample-local-module-1"
  example = "Hello world!"
}