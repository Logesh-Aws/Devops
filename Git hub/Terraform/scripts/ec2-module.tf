module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "Aws-key-pair"
  monitoring             = true
  vpc_security_group_ids = ["sg-013999596123e0844"]
  subnet_id              = "subnet-04ab37a20cd4eecd2"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}