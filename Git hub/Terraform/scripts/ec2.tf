data "aws_ami" "Linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20250610"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's correct owner ID for Ubuntu
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.Linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }

provisioner "local-exec" {
    command = <<EOT
      echo "Instance ID: ${self.id}" > details.txt
      echo "Private IP: ${self.private_ip}" >> details.txt
      echo "Public IP: ${self.public_ip}" >> details.txt
    EOT
  }
}
