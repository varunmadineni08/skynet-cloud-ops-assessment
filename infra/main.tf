resource "aws_vpc" "audit_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "audit-vpc"
  }
}

resource "aws_internet_gateway" "audit_igw" {
  vpc_id = aws_vpc.audit_vpc.id

  tags = {
    Name = "audit-igw"
  }
}

resource "aws_subnet" "pub_subnet_1" {
  vpc_id                  = aws_vpc.audit_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "pub_subnet_2" {
  vpc_id                  = aws_vpc.audit_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "audit_rt" {
  vpc_id = aws_vpc.audit_vpc.id

}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.audit_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.audit_igw.id
}

resource "aws_route_table_association" "subnet_1" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.audit_rt.id
}
resource "aws_route_table_association" "subnet_2" {
  subnet_id      = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.audit_rt.id
}

resource "aws_security_group" "audit_sg" {
  vpc_id = aws_vpc.audit_vpc.id
  name   = "audit-service-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_ecr_repository" "audit_ecr_repo" {
  name = "audit-service-ecr-repo"
}

resource "aws_iam_role" "ec2_role" {
  name = "audit-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_instance" "audit_ec2_1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.pub_subnet_1.id
  vpc_security_group_ids = [aws_security_group.audit_sg.id]
  key_name               = "docker-demo"

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "audit-instance-1"
  }
}

resource "aws_instance" "audit_ec2_2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.pub_subnet_2.id
  vpc_security_group_ids = [aws_security_group.audit_sg.id]
  key_name               = "docker-demo"

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "audit-instance-2"
  }
}


resource "aws_lb" "audit_lb" {
  name               = "audit-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.pub_subnet_1.id,
    aws_subnet.pub_subnet_2.id
  ]
  security_groups = [aws_security_group.audit_sg.id]
}

resource "aws_lb_target_group" "audit_tg" {
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.audit_vpc.id
}

resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.audit_tg.arn
  target_id        = aws_instance.audit_ec2_1.id
  port             = 8000
}
resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.audit_tg.arn
  target_id        = aws_instance.audit_ec2_2.id
  port             = 8000
}
resource "aws_lb_listener" "audit_http" {
  load_balancer_arn = aws_lb.audit_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.audit_tg.arn
  }
}