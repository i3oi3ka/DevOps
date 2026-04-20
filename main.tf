# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend" # Шлях до модуля
  bucket_name = var.bucket_name        # Ім'я S3-бакета береться зі змінної
  table_name  = var.table_name         # Ім'я DynamoDB береться зі змінної
}

# Підключаємо модуль для VPC
module "vpc" {
  source             = "./modules/vpc"        # Шлях до модуля VPC
  vpc_cidr_block     = var.vpc_cidr_block     # CIDR блок для VPC
  public_subnets     = var.public_subnets     # Публічні підмережі
  private_subnets    = var.private_subnets    # Приватні підмережі
  availability_zones = var.availability_zones # Зони доступності
  vpc_name           = var.vpc_name           # Ім'я VPC
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_name
  scan_on_push = var.scan_on_push
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = var.cluster_name           # Ім'я кластера
  region        = var.region                 # Назва кластера
  subnet_ids    = module.vpc.private_subnets # ID підмереж
  instance_type = var.instance_type          # Тип інстансів
  desired_size  = var.desired_size           # Бажана кількість нoдів
  max_size      = var.max_size               # Максимальна кількість нoдів
  min_size      = var.min_size               # Мінімальна кількість нoдів
}
