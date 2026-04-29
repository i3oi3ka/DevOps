# Отримуємо дані про VPC за її ID
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Security group (used by both)
resource "aws_security_group" "rds" {
  name        = "${var.rds_cluster_name}-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  # Виправлений блок: дозволяємо доступ з усієї VPC
  ingress {
    description = "Allow PostgreSQL traffic from the VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
