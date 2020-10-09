resource "aws_s3_bucket" "my_bucket" {
  bucket = "wl-terraform-training-${var.das}"
  acl    = "private"
}


