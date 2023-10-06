# Bastion host will be used for initial deployment and troubleshooting

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  root_block_device {
    delete_on_termination = true
    # iops                  = 150
    volume_size = 30
    volume_type = "gp3"
  }
  tags = {
    Name        = var.project_name
    Environment = var.env_name
  }

  depends_on = [aws_security_group.bastion]
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}