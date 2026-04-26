# terraform {
#   backend "s3" {
#     bucket         = "ruday-terraform-state-bucket-devOps" # Ім'я S3-бакета
#     key            = "lesson-8-9/terraform.tfstate"                 # Шлях до файлу стейту
#     region         = "eu-west-2"                                  # Регіон AWS
#     dynamodb_table = "ruday-terraform-locks-devOps"        # Назва таблиці DynamoDB
#     encrypt        = true                                         # Шифрування файлу стейту
#   }
# }
