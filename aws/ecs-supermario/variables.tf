variable "cidr_block" {
  type = map(string)
  default = {
    "vpc"      = "10.200.0.0/16"
    "subnet"   = "10.200.0.0/24"
    "internet" = "0.0.0.0/0"
  }
}

variable "tags" {
  type = map(string)
  default = {
    "vpc"    = "mario-public-subnet"
    "subnet" = "mario-public-subnet"
    "igw"    = "mario-igw"
    "rt"     = "mario-public-rt"
  }
}

variable "resource-name" {
  type = map(string)
  default = {
    "ecs-cluster"  = "mario-cluster"
    "ecs-task-def" = "mario-task-def"
    "ecs-image"    = "mario-image"
  }
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

