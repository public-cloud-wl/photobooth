resource "aws_iam_role" "allow_writing_to_my_bucket" {
  name = "AllowWritingToMyBucket-${var.das}"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "allow_writing_to_my_bucket" {
  name = aws_iam_role.allow_writing_to_my_bucket.name
  role = aws_iam_role.allow_writing_to_my_bucket.name
}

resource "aws_iam_role_policy" "allow_writing_to_my_bucket" {
  name = "AllowWritingToMyBucket-${var.das}"
  role = aws_iam_role.allow_writing_to_my_bucket.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:PutObject"
        ],
        "Effect": "Allow",
        "Resource": "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  }
  EOF
}


