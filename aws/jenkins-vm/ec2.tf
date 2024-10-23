################################################################################
# ALB
################################################################################

resource "aws_lb" "alb" {
  name               = "alb-jenkins"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

resource "aws_lb_target_group" "target-group-jenkins" {
  name     = "target-group-jenkins"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc1.id

  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled             = true
    port                = 8080
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.target-group-jenkins.arn
  target_id        = aws_instance.instance_jenkins.id
  port             = 8080
}

resource "aws_lb_listener" "https-alb1" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-jenkins.arn
  }
}

################################################################################
# Instance
################################################################################

resource "aws_instance" "instance_jenkins" {
  ami           = "ami-079db87dc4c10ac91"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet1.id
  key_name      = "ec2-jenkins"
  vpc_security_group_ids = [aws_security_group.sg-jenkins.id]
  associate_public_ip_address = true

  tags = {
    Name = "jenkins"
  }
}

################################################################################
# SG
################################################################################

resource "aws_security_group" "sg-alb" {
  name        = "alb-sg"
  description = "Permite 8080"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "8080 from Internet"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "sg-jenkins" {
  name        = "jenkins-sg"
  description = "Permite trafego do ALB"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description     = "8080 from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.sg-alb.id}"]

  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["187.181.254.83/32"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}