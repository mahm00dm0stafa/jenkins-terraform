output "jenkins_url" {
  value = "http://${aws_eip.eip.public_ip}:8080"
}