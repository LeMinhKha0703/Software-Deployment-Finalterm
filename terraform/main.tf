  # 1. Khai báo nhà cung cấp
  provider "aws" {
    region = "ap-southeast-1"
  }

  # 2. TỰ ĐỘNG TÌM AMI UBUNTU 22.04 MỚI NHẤT (Sửa lỗi InvalidAMIID)
  data "aws_ami" "ubuntu" {
    most_recent = true
    owners      = ["099720109477"] # Owner ID của Canonical (đơn vị tạo ra Ubuntu)

    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }
  }

  # 3. Tạo Security Group (Tường lửa)
resource "aws_security_group" "swarm_sg" {
  name        = "swarm-security-group-v2"
  description = "Allow SSH, Web, and Swarm traffic"

  # Cổng SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Cổng HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Cổng HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Cổng Nginx Proxy Manager UI
  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Cổng Grafana
  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Cổng Prometheus
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Các cổng cho Docker Swarm
  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  # 4. Tạo máy chủ Manager
  resource "aws_instance" "manager" {
    ami           = data.aws_ami.ubuntu.id # Sử dụng ID vừa tìm được ở trên
    instance_type = "t3.small"
    key_name      = "vinh-key" 

    vpc_security_group_ids = [aws_security_group.swarm_sg.id]

    root_block_device {
      volume_size = 20
      volume_type = "gp3"
      delete_on_termination = true
    }

    tags = { Name = "Swarm-Manager" }
  }

  # 5. Tạo máy chủ Worker
  resource "aws_instance" "worker" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t3.small"
    key_name      = "vinh-key"

    vpc_security_group_ids = [aws_security_group.swarm_sg.id]

    root_block_device {
      volume_size = 20
      volume_type = "gp3"
      delete_on_termination = true
    }

    tags = { Name = "Swarm-Worker" }
  }

  # 6. Xuất IP ra màn hình
  output "manager_ip" {
    value = aws_instance.manager.public_ip
  }

  output "worker_ip" {
    value = aws_instance.worker.public_ip
  }