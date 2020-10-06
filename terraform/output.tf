output "url"{
  value = "https://${aws_instance.my_instance.public_ip}:8443"
}
