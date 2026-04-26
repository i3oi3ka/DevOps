# 🚀 AWS End-to-End GitOps Infrastructure (Lesson 8-9)

Цей проєкт реалізує повний CI/CD цикл (GitOps) для Django-застосунку в хмарі AWS. Інфраструктура розгорнута за допомогою **Terraform**, автоматизація збірки — через **Jenkins**, а безперервна доставка — через **Argo CD**.

---

## 🏗 Архітектура та CI/CD процес

Проєкт реалізує сучасний підхід **GitOps**:

1. **Infrastructure as Code**: Весь кластер (VPC, EKS, ECR, S3 Backend) керується через Terraform.
2. **Continuous Integration**: Jenkins у Kubernetes використовує **Kaniko** для збірки Docker-образів без доступу до Docker-сокету хоста (Docker-in-Docker/Docker-less).
3. **Continuous Deployment**: Argo CD відстежує зміни в Helm-чарті та автоматично синхронізує стан кластера з Git.

---

## 📁 Структура проєкту

- **`main.tf`**, **`variables.tf`**, **`outputs.tf`**: Головні конфігураційні файли Terraform.
- **`backend.tf`**: Налаштування віддаленого збереження стану в S3.
- **`modules/`**:
  - `s3-backend`: Створення S3 та DynamoDB для Remote State та State Locking.
  - `vpc`: Мережева інфраструктура (Public/Private subnets, Internet Gateway, NAT).
  - `ecr`: Репозиторій для зберігання Docker-образів.
  - `eks`: Кластер Kubernetes та керовані групи вузлів (Managed Node Groups) + CSI Driver.
  - `jenkins`: Розгортання Jenkins через Helm (з налаштованими Kubernetes Clouds та агентами).
  - `argo_cd`: Розгортання Argo CD з використанням паттерну **App-of-Apps** (включає локальний чарт для автоматичного керування застосунками).
- **`charts/django-app/`**: Helm-чарт вашого додатку (Deployment, Service LoadBalancer, HPA, ConfigMap).

---

## 🛠 Prerequisites (Підготовка)

Перед початком роботи переконайтеся, що у вас встановлено та налаштовано:

- **Terraform** (версії 1.0 або новішої)
- **AWS CLI** (налаштований через команду `aws configure`)
- **kubectl** (для взаємодії з кластером Kubernetes)
- **Helm** (для роботи з чартами)
- **GitHub Personal Access Token (PAT)** з правами на читання/запис у репозиторій.

---

## ⚙️ Змінні (Variables)

Проєкт підтримує гнучке налаштування через змінні. Оголошені наступні параметри:

| Назва                | Опис                                                  | Тип            | За замовчуванням                                |
| :------------------- | :---------------------------------------------------- | :------------- | :---------------------------------------------- |
| `bucket_name`        | Назва S3 бакета для збереження стану Terraform        | `string`       | `ruday-terraform-state-bucket-devOps`           |
| `table_name`         | Назва DynamoDB таблиці для блокування стану Terraform | `string`       | `ruday-terraform-locks-devOps`                  |
| `vpc_name`           | Ім'я VPC                                              | `string`       | `DevOps-vpc`                                    |
| `vpc_cidr_block`     | CIDR блок для VPC                                     | `string`       | `10.0.0.0/16`                                   |
| `public_subnets`     | Список CIDR блоків для публічних підмереж             | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` |
| `private_subnets`    | Список CIDR блоків для приватних підмереж             | `list(string)` | `["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]` |
| `availability_zones` | Список зон доступності для підмереж                   | `list(string)` | `["eu-west-2a", "eu-west-2b", "eu-west-2c"]`    |
| `ecr_name`           | Назва ECR репозиторію                                 | `string`       | `DevOps-ecr-repository`                         |
| `scan_on_push`       | Чи вмикати сканування образів при завантаженні        | `bool`         | `true`                                          |
| `region`             | AWS region for deployment                             | `string`       | `eu-west-2`                                     |
| `cluster_name`       | Name of the EKS cluster                               | `string`       | `DevOps-eks-cluster`                            |
| `node_group_name`    | Name of the node group                                | `string`       | `DevOps-node-group`                             |
| `instance_type`      | EC2 instance type for the worker nodes                | `string`       | `t3.small`                                      |
| `desired_size`       | Desired number of worker nodes                        | `number`       | `2`                                             |
| `max_size`           | Maximum number of worker nodes                        | `number`       | `3`                                             |
| `min_size`           | Minimum number of worker nodes                        | `number`       | `1`                                             |
| `name`               | Назва Helm-релізу Argo CD                             | `string`       | `argo-cd`                                       |
| `namespace`          | K8s namespace для Argo CD                             | `string`       | `argocd`                                        |
| `chart_version`      | Версія Argo CD чарта                                  | `string`       | `9.5.4`                                         |

---

### Приклад конфігурації `terraform.tfvars`:

Створіть цей файл у кореневій директорії проєкту, щоб передати власні значення:

```hcl
bucket_name        = "your-unique-bucket-name"
table_name         = "your-unique-table-name"

vpc_name           = "your-vpc-name"
vpc_cidr_block     = "your-vpc-cidr-block"
public_subnets     = ["your-public-subnet-1", "your-public-subnet-2", "your-public-subnet-3"]
private_subnets    = ["your-private-subnet-1", "your-private-subnet-2", "your-private-subnet-3"]
availability_zones = ["your-availability-zone-1", "your-availability-zone-2", "your-availability-zone-3"]

ecr_name           = "your-ecr-repository-name"
scan_on_push       = true

region             = "your-aws-region"
cluster_name       = "your-eks-cluster-name"
node_group_name    = "your-node-group-name"
instance_type      = "your-ec2-instance-type"
desired_size       = 2
max_size           = 3
min_size           = 1
name               = "your-argo-cd-release-name"
namespace          = "your-argo-cd-namespace"
chart_version      = "your-argo-cd-chart-version"
```

## 🚀 Порядок розгортання

### 1. Bootstrapping (Перший запуск інфраструктури)

Оскільки проєкт використовує S3 для збереження стану, який сам же і створює, перший запуск має відбуватися так:

1. Закоментуйте весь вміст файлу `backend.tf`.
2. Виконайте ініціалізацію та створення ресурсів:
   ```bash
   terraform init
   terraform apply
   ```
3. Розкоментуйте `backend.tf`, впишіть туди назву створеного бакету та таблиці DynamoDB.
4. Виконайте `terraform init` ще раз і погодьтеся на міграцію стейту в AWS (`yes`).
5. Знову виконайте `terraform apply` для завершення розгортання всієї інфраструктури.

### 2. Секрети додатку (Kubernetes)

Підключення до EKS:

```bash
aws eks --region eu-west-2 update-kubeconfig --name DevOps-eks-cluster
```

Django вимагає обов'язковий `SECRET_KEY`. Для безпеки ми передаємо його через Kubernetes Secret, а не зберігаємо у Git:

```bash
kubectl create secret generic django-secrets \
  --from-literal=SECRET_KEY='your-random-secret-key-here' \
  --namespace default
```

### 3. Налаштування Jenkins

Оскільки ми використовуємо підхід "Configuration as Code", облікові дані (`github-token`) створюються автоматично під час встановлення Helm-чарту.

1. Перед розгортанням інфраструктури відкрийте файл конфігурації Jenkins (`modules/jenkins/values.yaml` або відповідний файл зі змінними).
2. Знайдіть блок створення credentials і заповніть ваші дані:
   - `username`: Ваш логін на GitHub.
   - `password`: Ваш GitHub Personal Access Token (PAT).
3. Для отримання посилання на load balancer Jenkins виконайте команду:
   ```bash
   kubectl get svc -n jenkins jenkins -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
   ```

### 4. Налаштування Argo CD

Argo CD автоматично розгортається та налаштовується модулем Terraform.
Для отримання посилання на сервіс Argo CD виконайте команду:

```bash
kubectl get svc -n argocd argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

- **Логін**: `admin`
- **Пароль**: Отримайте з кластера командою:
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
  ```

## 🔄 Як працює автоматизація (CI/CD Workflow)

1. **Push**: Ви робите коміт у Git-репозиторій (зміни в коді Django).
2. **Jenkins Build**: Jenkins автоматично виявляє зміни (через Poll SCM), запускає тимчасовий Pod у Kubernetes з контейнерами **Git** та **Kaniko**.
3. **Build & Push**: Kaniko збирає новий Docker-образ і пушить його в Amazon ECR з унікальним тегом (номер білда `${BUILD_NUMBER}`).
4. **GitOps Update (CD Trigger)**: Jenkins клонує репозиторій, змінює значення `tag:` у файлі `charts/django-app/values.yaml` на нове та робить `git push` назад у репозиторій.
5. **Argo CD Sync**: Argo CD постійно сканує репозиторій. Побачивши новий тег у `values.yaml`, він ініціює синхронізацію і виконує Rolling Update подів Django у кластері без простою.

---

## ⚙️ Команди для перевірки

- **Отримати URL вашого працюючого веб-додатку Django**:

  ```bash
    kubectl get svc django-app-django -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
  ```

- **Перевірити статуси подів додатку**:

  ```bash
  kubectl get pods -n default
  ```

- **Статус синхронізації Argo CD через CLI**:

  ```bash
  kubectl get applications -n argocd
  ```

- **Знищення всієї інфраструктури (Clean up)**:

  ```bash
  terraform destroy
  ```

---

## 📤 Outputs (Вихідні дані)

Після завершення `terraform apply` ви отримаєте:

- `s3_bucket_name`: Назва S3-бакета для стейту.
- `dynamodb_table_name`: Назва таблиці DynamoDB для блокування.
- `vpc_id`: Ідентифікатор мережі.
- `public_subnets`: Список публічних підмереж.
- `private_subnets`: Список приватних підмереж.
- `internet_gateway_id`: Ідентифікатор інтернет-шлюзу.
- `eks_cluster_endpoint`: URL-адреса API сервера EKS.
- `eks_cluster_name`: Ім'я кластера EKS.
- `eks_node_role_arn`: ARN ролі для вузлів EKS.
- `ecr_repository_url`: URL вашого ECR репозиторію.
- `jenkins_release`: Назва релізу Jenkins.
- `jenkins_namespace`: Простір імен для Jenkins.
- `argo_cd_server_service`: URL-адреса сервісу Argo CD
  `admin_password`: Пароль адміністратора Argo CD.

---
