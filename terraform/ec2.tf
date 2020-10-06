data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}
resource "aws_iam_instance_profile" "allow_writing_to_my_bucket" {
  name = aws_iam_role.allow_writing_to_my_bucket.name
  role = aws_iam_role.allow_writing_to_my_bucket.name
}

resource "aws_instance" "my_instance" {
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.allow_writing_to_my_bucket.name
  security_groups      = [aws_security_group.allow_wl.name]
  user_data            = <<-EOF
    #!/bin/bash
    curl -L -O https://github.com/Filirom1/photobooth/releases/download/v0.0.2/photobooth.tar.gz
    tar xvzf photobooth.tar.gz
    cd photobooth
    export AWS_REGION=${aws_s3_bucket.my_bucket.region}
    export AWS_BUCKET=${aws_s3_bucket.my_bucket.bucket}
    nohup ./photobooth &
  EOF
  tags = {
    Name = "photobooth"
  }
}
