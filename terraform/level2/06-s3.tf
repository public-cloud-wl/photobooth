resource "aws_s3_bucket" "my_bucket" {
  bucket = "wl-terrform-training-${var.das}"
  acl    = "private"
}


