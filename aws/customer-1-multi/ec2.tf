################################################################################
# Instâncias
################################################################################

########## Gitlab-01

resource "aws_instance" "gitlab-01" {
  ami                         = "ami-0cd690123f92f5079"
  instance_type               = "t3.medium"
  subnet_id                   = module.vpc.public_subnets[0]
  key_name                    = "gitlab-01"
  vpc_security_group_ids      = [module.sg-gitlab-01.security_group_id]
  associate_public_ip_address = true

  root_block_device {
    tags = merge(var.tags, { Name = "${local.resource-prefix}-gitlab-01-ebs-root" })
  }

  tags = merge(var.tags, { Name = "${local.resource-prefix}-gitlab-ec2-instance-01" })
}

resource "aws_ebs_volume" "gitlab-01-01" {
  availability_zone = "sa-east-1a"
  size              = 100
  type              = "gp3"
  encrypted         = true
  tags              = merge(var.tags, { Name = "${local.resource-prefix}-gitlab-01-ebs-01" })
}

resource "aws_volume_attachment" "gitlab-01-01" {
  device_name = "/dev/sdb"
  instance_id = aws_instance.gitlab-01.id
  volume_id   = aws_ebs_volume.gitlab-01-01.id
}

################################################################################
# Grupos de segurança
################################################################################

########## Gitlab-01

module "sg-gitlab-01" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.2.0"
  name    = "${local.resource-prefix}-sg-gitlab-01"
  vpc_id  = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = var.allowed_ips
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = var.allowed_ips
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.tags
}

########## RDS-01

module "sg-rds-01" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.2.0"
  name    = "${local.resource-prefix}-sg-rds-01"
  vpc_id  = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "mysql-tcp"
      cidr_blocks = var.allowed_ips
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = var.tags
}

######### MQ-01

module "sg-mq-01" {
  source  = "terraform-aws-modules/security-group/aws//modules/rabbitmq"
  version = "~> 5.2.0"
  name    = "${local.resource-prefix}-sg-mq-01"
  vpc_id  = module.vpc.vpc_id

  tags = var.tags
}