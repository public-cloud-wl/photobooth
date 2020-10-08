resource "aws_security_group" "my_security_group" {
  name        = var.das
  description = "Allow traffic for ${var.das}"

  ingress {
    description = "HTTPS From Worldline"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["160.92.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
