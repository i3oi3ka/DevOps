terraform {
  backend "s3" {
    bucket         = "ruday-lesson-5-terraform-state-bucket-1"
    key            = "lesson-5/terraform.tfstate"   # Шлях до файлу стейту
    region         = "us-west-2"                    # Регіон AWS
    dynamodb_table = "ruday-lesson-5-terraform-locks"             # Назва таблиці DynamoDB
    encrypt        = true                           # Шифрування файлу стейту
  }
}

