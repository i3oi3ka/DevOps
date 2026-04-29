data "aws_ami" "nat" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "nat_instance" {
  name        = "${var.vpc_name}-nat-instance-sg"
  description = "Allow private subnets to reach the internet through the NAT instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Traffic from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-nat-instance-sg"
  }
}

resource "aws_instance" "nat" {
  ami                         = data.aws_ami.nat.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.nat_instance.id]
  associate_public_ip_address = true
  source_dest_check           = false

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    yum update -y
    yum install -y iptables-services
    sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-nat.conf
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    service iptables save
    systemctl enable iptables
    systemctl restart iptables
  EOF

  tags = {
    Name = "${var.vpc_name}-nat-instance"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route" "private_nat_instance" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat.primary_network_interface_id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
