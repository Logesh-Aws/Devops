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

  owners = ["099720109477"] # Canonical
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.Linux.id
  instance_type = "t2.micro"
  key_name      = "Aws-key-pair" # Replace with your key pair name

  tags = {
    Name = "Linux-1"
  }
}

# Write instance details locally
resource "null_resource" "write_details" {
  depends_on = [aws_instance.web]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      Start-Sleep -Seconds 10;
      $details = @()
      $details += "Instance ID: ${aws_instance.web.id}`nPrivate IP: ${aws_instance.web.private_ip}`nPublic IP: ${aws_instance.web.public_ip}`n"
      $details -join "`n" | Out-File -FilePath details.txt -Encoding utf8
    EOT
  }

  # Copy details.txt to EC2 instance
  provisioner "file" {
    source      = "./details.txt"
    destination = "/home/ubuntu/details.txt"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.web.public_ip
      private_key = file("./Aws-key-pair.pem") # Ensure this file exists and is chmod 400
    }
  }
}
