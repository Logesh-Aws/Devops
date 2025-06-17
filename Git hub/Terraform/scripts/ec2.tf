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

  owners = ["099720109477"]
}

# First EC2 instance
resource "aws_instance" "web1" {
  ami           = data.aws_ami.Linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "Linux-1"
  }
}

# Second EC2 instance
resource "aws_instance" "web2" {
  ami           = data.aws_ami.Linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "Linux-2"
  }
}

# Second EC2 instance
resource "aws_instance" "web3" {
  ami           = data.aws_ami.Linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "Linux-3"
  }
}

# Single provisioner to write all instance details
resource "null_resource" "write_all_details" {
  depends_on = [aws_instance.web1, aws_instance.web2]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
      Start-Sleep -Seconds 10;
      $details = @()
      $details += "Instance ID: ${aws_instance.web1.id}`nPrivate IP: ${aws_instance.web1.private_ip}`nPublic IP: ${aws_instance.web1.public_ip}`n"
      $details += "Instance ID: ${aws_instance.web2.id}`nPrivate IP: ${aws_instance.web2.private_ip}`nPublic IP: ${aws_instance.web2.public_ip}`n"
      $details += "Instance ID: ${aws_instance.web2.id}`nPrivate IP: ${aws_instance.web2.private_ip}`nPublic IP: ${aws_instance.web2.public_ip}`n"

      $details -join "`n" | Out-File -FilePath details.txt -Encoding utf8
    EOT
  }
}
