# Підключаємо модуль для S3 та DynamoDB
# module "s3_backend" {
#   source      = "./modules/s3-backend"                                         # Шлях до модуля
#   bucket_name = var.bucket_name || "ruday-lesson-7-terraform-state-bucket-1101" # Ім'я S3-бакета береться зі змінної
#   table_name  = var.table_name || "ruday-lesson-7-terraform-locks-1101"         # Ім'я DynamoDB береться зі змінної
# }

# Підключаємо модуль для VPC
module "vpc" {
  source             = "./modules/vpc"                                                      # Шлях до модуля VPC
  vpc_cidr_block     = var.vpc_cidr_block || "10.0.0.0/16"                                  # CIDR блок для VPC
  public_subnets     = var.public_subnets || ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]  # Публічні підмережі
  private_subnets    = var.private_subnets || ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] #                              # Приватні підмережі
  availability_zones = var.availability_zones || ["us-east-1a", "us-east-1b", "us-east-1c"] # Зони доступності
  vpc_name           = var.vpc_name || "my-vpc"                                             # Ім'я VPC
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_name || "ruday-lesson-7-ecr-1101"
  scan_on_push = var.scan_on_push || true
}
