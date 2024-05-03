data "aws_ami" "amazon_linux" {
  owners = ["amazon"]
  most_recent      = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240401.1-kernel-6.1-x86_64"]
  }
}