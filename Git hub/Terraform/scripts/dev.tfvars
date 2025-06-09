vpc_name = "dev-vpc"
cidr = "10.0.0.0/16"
pub-sub = "10.0.1.0/24"  
Pvt-sub = "10.0.2.0/24"


# Default the terraform will pick only var.tf for passing variables.
# To pick dev.tfvars to pass variable give below command.Name.
# terraform apply --var-file=dev.tfvars