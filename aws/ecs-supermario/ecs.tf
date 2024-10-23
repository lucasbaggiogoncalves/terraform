resource "aws_ecs_cluster" "mario" {
  name = var.resource-name.ecs-cluster
}

resource "aws_ecs_task_definition" "mario" {
  family = var.resource-name.ecs-task-def
  container_definitions = jsonencode([
    {
      name      = var.resource-name.ecs-image
      image     = "sevenajay/mario"
      cpu       = 1
      memory    = 2
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 80
        }
      ]
    }
  ])
  volume {
    name      = "marioapp-storage"
    host_path = "/ecs/marioapp-storage"
  }
}