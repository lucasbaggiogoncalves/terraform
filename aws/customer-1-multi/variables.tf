################################################################################
# Secrets - Terraform Cloud - Valores são sensíveis e não podem ser
# recuperados posteriormente
################################################################################

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}

variable "AWS_REGION" {
  type = string
}

variable "RDS-01_PASSWORD" {
  type      = string
  sensitive = true
}

variable "MQ-01_PASSWORD" {

}

################################################################################
# Ambiente
################################################################################

variable "environment" {
  type    = string
  default = "prd"
}

variable "region" {
  type    = string
  default = "sae1"
}

variable "avaliability_zones" {
  type    = list(string)
  default = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
}

variable "tags" {
  type = map(string)
  default = {
    "Terraform"   = "true"
    "Environment" = "prd"
  }
}

################################################################################
# Definições dos recursos
################################################################################

########## VPC

variable "vpc_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "subnets_cidr" {
  type = map(map(list(string)))
  default = {
    "private" = {
      "public_subnets"  = ["10.100.0.0/20", "10.100.64.0/20", "10.100.128.0/20"]
      "private_subnets" = ["10.100.16.0/20", "10.100.80.0/20", "10.100.144.0/20"]
      "intra_subnets"   = ["10.100.32.0/20", "10.100.96.0/20", "10.100.160.0/20"]
    }
  }
}

########## EKS

variable "eks_01_service_ip" {
  type    = string
  default = "10.50.0.0/16"
}

################################################################################
# Acesso aos recursos
################################################################################

variable "allowed_ips" { # IPs para acessos externos aos recursos, separado por vírgula
  type    = string
  default = "1.1.1.1" # Em ordem ("Customer" )
}

variable "iam_eks_access_entries" {
  type = map(string)
  default = {
    "name" = "arn"
  }
}