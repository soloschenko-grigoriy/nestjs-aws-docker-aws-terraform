resource "aws_ecs_cluster" "nestjs-ecs-cluster" {
  name = "ecs-cluster-for-nestjs"
}

resource "aws_ecs_service" "nestjs-ecs-service-two" {
  name            = "nestjs-app"
  cluster         = aws_ecs_cluster.nestjs-ecs-cluster.id
  task_definition = aws_ecs_task_definition.nestjs-ecs-task-definition.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["subnet-05t93f90b22ba76qx"]
    assign_public_ip = true
  }
  desired_count = 1
}

resource "aws_ecs_task_definition" "nestjs-ecs-task-definition" {
  family                   = "ecs-task-definition-nestjs"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
  container_definitions    = <<EOF
[
  {
    "name": "nestjs-container",
    "image": "150184932832.dkr.ecr.us-east-1.amazonaws.com/nestjs-repo:latest",
    "memory": 1024,
    "cpu": 512,
    "essential": true,
    "entryPoint": ["/"],
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 80
      }
    ]
  }
]
EOF
}