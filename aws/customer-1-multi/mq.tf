################################################################################
# Broker
################################################################################

resource "aws_mq_broker" "rabbitmq-01" {
  broker_name = "${local.resource-prefix}-mq-01"

  configuration {
    id       = aws_mq_configuration.rabbitmq-01.id
    revision = aws_mq_configuration.rabbitmq-01.latest_revision
  }

  engine_type        = "RabbitMQ"
  engine_version     = "3.13"
  host_instance_type = "mq.t3.micro"
  deployment_mode    = "SINGLE_INSTANCE"

  publicly_accessible = false
  subnet_ids          = [module.vpc.private_subnets[0]]
  security_groups     = [module.vpc.default_security_group_id]

  user {
    username = "adminmquser"
    password = var.MQ-01_PASSWORD # mínimo 12 caracteres
  }

  maintenance_window_start_time {
    day_of_week = "SUNDAY"
    time_of_day = "04:00"
    time_zone   = "UTC"
  }

  auto_minor_version_upgrade = true

  tags = var.tags

}

################################################################################
# Configuração
################################################################################

resource "aws_mq_configuration" "rabbitmq-01" {
  description    = "Configuração RabbitMQ 3.13"
  name           = "${local.resource-prefix}-mq-configuration-01"
  engine_type    = "RabbitMQ"
  engine_version = "3.13"

  tags = var.tags

  data = <<DATA
# Management header is set to true to enable Content-Type-Options, Frame-Options, and HSTS headers by default
secure.management.http.headers.enabled = true
# Default RabbitMQ delivery acknowledgement timeout is 30 minutes
consumer_timeout = 1800000
  DATA
}