terraform {
  backend "s3" {
    bucket = "kha-app-s3"  # Tên của bucket S3 bạn đã tạo
    key    = "state/terraform.tfstate"  # Đường dẫn đến file trạng thái
    region = "ap-southeast-1"  # Vùng AWS mà bucket S3 của bạn nằm trong đó
  }
}