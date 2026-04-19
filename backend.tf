terraform {
  backend "s3" {
    bucket         = "ruday-lesson-7-terraform-state-bucket-1101" # Ім'я S3-бакета
    key            = "lesson-7/terraform.tfstate"                 # Шлях до файлу стейту
    region         = "eu-west-2"                                  # Регіон AWS
    dynamodb_table = "ruday-lesson-7-terraform-locks-1101"        # Назва таблиці DynamoDB
    encrypt        = true                                         # Шифрування файлу стейту
  }
}
