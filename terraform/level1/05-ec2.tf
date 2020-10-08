resource "aws_instance" "my_instance" {
  ami                  = "ami-0697b068b80d79421"
  instance_type        = "t2.micro"

  security_groups      = [aws_security_group.my_security_group.name]

  user_data            = <<-EOF
    #!/bin/bash
    curl -L -o photobooth.tar.gz https://bit.ly/3iK4hnw
    tar xvzf photobooth.tar.gz
    cd photobooth
    nohup ./photobooth &
  EOF

  tags = {
    Name = "photobooth ${var.das}"
  }
}


