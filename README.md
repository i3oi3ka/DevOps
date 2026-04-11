# AWS Terraform Infrastructure (Lesson 5)

Проєкт розгортання модульної інфраструктури в AWS за допомогою Terraform.

## 🏗 Структура проєкту

- **main.tf** — точка входу, виклик модулів.
- **backend.tf** — налаштування Remote State (S3 + DynamoDB).
- **modules/** — папка з функціональними блоками:
  - **s3-backend**: Створює бакет для стейт-файлу та таблицю DynamoDB для блокувань.
  - **vpc**: Створює мережу (VPC), публічні та приватні підмережі, IGW та таблиці маршрутизації.
  - **ecr**: Створює репозиторій для Docker-образів з політикою життєвого циклу.

## 🚀 Основні команди

- terraform plan # Перегляд запланованих змін
- terraform apply # Створення інфраструктури (потрібне підтвердження 'yes')
- terraform destroy # Повне видалення ресурсів

## 📦 Опис модулів

### s3-backend

**Призначення**: Зберігання стану

**Ключові ресурси**: S3 Bucket, DynamoDB Table (LockID)

### vpc

**Призначення**: Мережа

**Ключові ресурси**: VPC, Subnets (Public/Private), Internet Gateway

### ecr

**Призначення**: Контейнери

**Ключові ресурси**: ECR Repository, Lifecycle Policy, Image Scanning
