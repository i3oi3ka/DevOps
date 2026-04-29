# terraform {
#   backend "s3" {
#     bucket         = "ruday-terraform-state-bucket-devops" # Ім'я S3-бакета
#     key            = "devops/terraform.tfstate"                 # Шлях до файлу стейту
#     region         = "eu-west-2"                                  # Регіон AWS
#     dynamodb_table = "ruday-terraform-locks-devops"        # Назва таблиці DynamoDB
#     encrypt        = true                                         # Шифрування файлу стейту
#   }
# }
