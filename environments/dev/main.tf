provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

module "keypair" {
  source   = "../../modules/keypair"
  key_name = var.key_name
}

module "security_group" {
  source = "../../modules/security-group"
  vpc_id = var.vpc_id
}

module "ec2" {
  source            = "../../modules/ec2"
  ami               = data.aws_ami.ubuntu_2204.id
  instance_type     = var.instance_type
  key_name          = module.keypair.key_name
  security_group_id = module.security_group.id
}
