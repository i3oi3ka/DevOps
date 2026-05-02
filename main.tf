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
  subnet_ids    = module.vpc.private_subnets # ID приватних підмереж
  instance_type = var.instance_type          # Тип інстансів
  desired_size  = var.desired_size           # Бажана кількість нoдів
  max_size      = var.max_size               # Максимальна кількість нoдів
  min_size      = var.min_size               # Мінімальна кількість нoдів

  depends_on = [
    module.vpc
  ]
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks
  ]
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks
  ]
}

# Налаштування для Helm
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks
  ]
}

moved {
  from = kubernetes_secret.django_secret
  to   = kubernetes_secret_v1.django_secret
}

resource "kubernetes_secret_v1" "django_secret" {
  metadata {
    name      = "django-secret"
    namespace = "default"
  }

  data = {
    POSTGRES_DB       = var.db_name
    POSTGRES_USER     = var.username
    POSTGRES_PASSWORD = var.password
    SECRET_KEY        = var.django_secret_key
  }

  type = "Opaque"

  depends_on = [
    module.eks,
    module.rds,
    module.argo_cd
  ]
}

module "jenkins" {
  source                 = "./modules/jenkins"
  cluster_name           = module.eks.cluster_name
  oidc_provider_arn      = module.eks.oidc_provider_arn
  oidc_provider_url      = module.eks.oidc_provider_url
  kubeconfig             = "~/.kube/config"
  github_username        = var.github_username
  github_token           = var.github_token
  jenkins_admin_password = var.jenkins_admin_password

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }

  depends_on = [
    module.eks
  ]
}


module "argo_cd" {
  source               = "./modules/argo_cd"
  namespace            = var.namespace
  chart_version        = var.chart_version
  django_postgres_host = module.rds.db_host
  django_postgres_port = module.rds.db_port
}


module "rds" {
  source = "./modules/rds"

  rds_cluster_name      = var.rds_cluster_name
  use_aurora            = var.use_aurora
  aurora_instance_count = var.aurora_instance_count


  # --- Aurora-only ---
  engine_cluster                = var.engine_cluster
  engine_version_cluster        = var.engine_version_cluster
  parameter_group_family_aurora = var.parameter_group_family_aurora

  # --- RDS-only ---
  engine                     = var.engine
  engine_version             = var.engine_version
  parameter_group_family_rds = var.parameter_group_family_rds

  # common
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  subnet_private_ids      = module.vpc.private_subnets
  subnet_public_ids       = module.vpc.public_subnets
  publicly_accessible     = var.publicly_accessible
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr_block          = var.vpc_cidr_block
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  parameters              = var.parameters

  tags = {
    Environment = "dev"
    Project     = "lesson-db"
  }
}

module "monitoring" {
  source                    = "./modules/monitoring"
  grafana_admin_password    = var.grafana_admin_password
  prometheus_admin_password = var.prometheus_admin_password
}
