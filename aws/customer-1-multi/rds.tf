################################################################################
# Grupo de subnets
################################################################################

resource "aws_db_subnet_group" "rds-subnet-group-01" {
  name       = "${local.resource-prefix}-rds-subnet-group-01"
  subnet_ids = [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]]

  tags = var.tags
}

################################################################################
# Instancia
################################################################################

resource "aws_db_instance" "rds-instance-01" {
  identifier                 = "${local.resource-prefix}-rds-instance-01"
  engine                     = "mysql"
  engine_version             = "8.0"
  auto_minor_version_upgrade = true

  instance_class = "db.t3.medium"
  username       = "admindbuser"
  password       = var.RDS-01_PASSWORD

  storage_type          = "gp3"
  allocated_storage     = 50
  max_allocated_storage = 100
  storage_encrypted     = true

  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group-01.name
  availability_zone      = "sa-east-1a"
  vpc_security_group_ids = [module.sg-rds-01.security_group_id]
  publicly_accessible    = true
  skip_final_snapshot    = true

  backup_window      = "01:00-03:00"
  maintenance_window = "Mon:03:01-Mon:05:00"

  tags = var.tags
}