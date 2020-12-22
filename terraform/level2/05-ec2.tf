resource "aws_instance" "my_instance" {
  ami           = "ami-0697b068b80d79421"
  instance_type = "t3.micro"

  security_groups = [aws_security_group.my_security_group.name]

  user_data = <<-EOF
    #!/bin/bash
    echo 'AWS_REGION=${aws_s3_bucket.my_bucket.region}' > /etc/photobooth
    echo 'AWS_BUCKET=${aws_s3_bucket.my_bucket.bucket}' >> /etc/photobooth
    yum install -y https://github.com/Filirom1/photobooth/releases/download/v0.0.2/photobooth-0.0.2-1.x86_64.rpm
  EOF

  tags = {
    Name = "photobooth ${var.das}"
  }

  iam_instance_profile = aws_iam_instance_profile.allow_writing_to_my_bucket.name

}


