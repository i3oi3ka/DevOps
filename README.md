# AWS Infrastructure Deployment (Lesson 5)

Цей проєкт реалізує розгортання модульної хмарної інфраструктури в AWS за допомогою Terraform. Він включає налаштування ізольованої мережі (VPC), сховища для Docker-образів (ECR) та віддаленого бекенду для безпечного зберігання стану.

## 🛠 Prerequisites (Підготовка)

Перед початком роботи переконайтеся, що у вас встановлено:

- **Terraform** (версії 1.0 або новішої).
- **AWS CLI** (налаштований через команду `aws configure`).
- Наявність IAM-користувача з достатніми правами доступу для створення ресурсів VPC, ECR, S3 та DynamoDB.

---

## 🏗 Структура проєкту

Проєкт розділений на логічні модулі для забезпечення зручності керування ресурсами:

- **`modules/s3-backend`**: Створює S3-бакет та DynamoDB таблицю для віддаленого збереження стану Terraform (`terraform.tfstate`) та механізму State Locking.
- **`modules/vpc`**: Розгортає Virtual Private Cloud (VPC), публічні та приватні підмережі, Internet Gateway та таблиці маршрутизації.
- **`modules/ecr`**: Створює репозиторій для Docker-образів з налаштуванням сканування на вразливості.
- **`modules/eks`**: Розгортає кластер EKS та групу вузлів для запуску контейнеризованих додатків.
- **`main.tf`**: Головний файл проєкту, де викликаються всі модулі.
- **`variables.tf`**: Оголошення вхідних змінних для конфігурації модулів.
- **`backend.tf`**: Конфігурація підключення до віддаленого S3-сховища.
- **`outputs.tf`**: Опис вихідних даних для отримання ідентифікаторів створених ресурсів.
- **`terraform.tfvars`**: Файл для зберігання значень змінних (не включений до репозиторію, створюється користувачем).

---

## ⚙️ Змінні (Variables)

Проєкт підтримує гнучке налаштування через змінні. Оголошені наступні параметри:

| Назва                | Опис                                           | Тип            | За замовчуванням                              |
| :------------------- | :--------------------------------------------- | :------------- | :-------------------------------------------- |
| `bucket_name`        | Назва S3 бакета для збереження стану Terraform | `string`       | `ruday-lesson-7-terraform-state-bucket-1101`  |
| `table_name`         | Назва DynamoDB таблиці для блокування стану    | `string`       | `ruday-lesson-7-terraform-locks-1101`         |
| `vpc_name`           | Ім'я VPC                                       | `string`       | `ruday-lesson-7-vpc-1101`                     |
| `vpc_cidr_block`     | CIDR блок для VPC                              | `string`       | `10.0.0.0/16`                                 |
| `public_subnets`     | Список CIDR блоків для публічних підмереж      | `list(string)` | [`10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24`] |
| `private_subnets`    | Список CIDR блоків для приватних підмереж      | `list(string)` | [`10.0.4.0/24`, `10.0.5.0/24`, `10.0.6.0/24`] |
| `availability_zones` | Список зон доступності для підмереж            | `list(string)` | [`eu-west-2a`, `eu-west-2b`, `eu-west-2c`]    |
| `ecr_name`           | Назва ECR репозиторію                          | `string`       | `ruday-lesson-7-ecr-1101`                     |
| `scan_on_push`       | Чи вмикати сканування образів при завантаженні | `bool`         | `true`                                        |
| `region`             | Регіон для розгортання ресурсів                | `string`       | `eu-west-2`                                   |
| `cluster_name`       | Назва EKS кластера                             | `string`       | `lesson-7-eks-cluster`                        |
| `node_group_name`    | Назва групи вузлів EKS                         | `string`       | `lesson-7-node-group`                         |
| `instance_type`      | Тип EC2 інстансу для вузлів EKS                | `string`       | `t2.micro`                                    |
| `desired_size`       | Бажана кількість вузлів у групі EKS            | `number`       | `2`                                           |
| `max_size`           | Максимальна кількість вузлів у групі EKS       | `number`       | `3`                                           |
| `min_size`           | Мінімальна кількість вузлів у групі EKS        | `number`       | `1`                                           |

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
subnet_ids        = ["your-subnet-id-1", "your-subnet-id-2", "your-subnet-id-3"]
node_group_name    = "your-node-group-name"
instance_type      = "your-ec2-instance-type"
desired_size       = 2
max_size           = 3
min_size           = 1

```

---

## 🚀 Порядок першого розгортання (Bootstrapping)

Оскільки проект використовує S3 для зберігання стану, який сам же і створює, перший запуск має відбуватися за наступним алгоритмом:

1. **Тимчасове вимкнення бекенду**:
   Закоментуйте весь вміст файлу `backend.tf`. Це змусить Terraform зберігати стан локально на вашому комп'ютері під час створення бакета.

2. **Створення базових ресурсів**:
   Виконайте ініціалізацію та застосуйте конфігурацію:

   ```bash
   terraform init
   terraform apply
   ```

   _Terraform створить S3-бакет та DynamoDB-таблицю._

3. **Активація віддаленого бекенду**:
   Розкоментуйте вміст файлу `backend.tf` та внесіть відповідні значення в полях змінних.

4. Тепер, коли бакет у хмарі вже існує, виконайте повторну ініціалізацію:

   ```bash
   terraform init
   ```

   _Terraform запитає: "Do you want to copy existing state to the new backend?". Введіть **yes**._

Тепер ваш проект повністю перейшов на хмарне зберігання стану, і локальний файл `.tfstate` можна видалити.

## 🚀 Команди для керування інфраструктурою

Для роботи з проєктом використовуйте стандартний робочий процес Terraform у кореневій директорії:

1. **Ініціалізація проєкту**:
   ```bash
   terraform init
   ```
2. **Перегляд плану інфраструктури**:
   ```bash
   terraform plan
   ```
3. **Розгортання інфраструктури**:
   ```bash
   terraform apply
   ```
4. **Видалення інфраструктури**:
   ```bash
   terraform destroy
   ```

---

## 📤 Вихідні дані (Outputs)

Після успішного виконання команди `terraform apply`, у термінал будуть виведені ключові дані:

- **`s3_bucket_name`**: Назва створеного S3-бакета для збереження стану Terraform.
- **`dynamodb_table_name`**: Назва створеної DynamoDB таблиці для блокування стану.
- **`vpc_id`**: Унікальний ідентифікатор створеної віртуальної мережі.
- **`public_subnet_ids`**: Список ідентифікаторів публічних підмереж.
- **`private_subnet_ids`**: Список ідентифікаторів приватних підмереж.
- **`internet_gateway_id`**: Ідентифікатор створеного Internet Gateway.
- **`ecs_cluster_endpoint`**: URL-адреса API сервера EKS кластера для взаємодії з Kubernetes.
- **`eks_cluaster_name`**: Назва створеного EKS кластера.
- **`eks_node_role_arn`**: ARN ролі IAM, яка використовується вузлами EKS для взаємодії з іншими сервісами AWS.
- **`ecr_repository_url`**: URL-адреса створеного репозиторію ECR для завантаження Docker-образів.

---
