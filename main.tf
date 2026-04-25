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
}

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name
  depends_on = [
    module.eks
  ]
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
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

module "jenkins" {
  source            = "./modules/jenkins"
  cluster_name      = module.eks.eks_cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  kubeconfig        = "~/.kube/config"

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }

  depends_on = [
    module.eks
  ]
}


module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = var.namespace
  chart_version = var.chart_version
}
