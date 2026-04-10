# Підключаємо модуль для S3 та DynamoDB
module "s3_backend" {
  source = "./modules/s3-backend"                # Шлях до модуля
  bucket_name = "ruday-lesson-5-terraform-state-bucket-1"  # Ім'я S3-бакета
  table_name  = "ruday-lesson-5-terraform-locks"                # Ім'я DynamoDB
}
