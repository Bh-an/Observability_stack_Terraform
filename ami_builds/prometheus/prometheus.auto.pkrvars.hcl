
aws_region = "ap-south-1"
source_ami = "ami-0d0ad8bb301edb745"
ami_prefix = "prometheus-ha"

vpc_id    = "vpc-0ad80dbeedb291d03" 
subnet_id = "subnet-023dcb0dc24c6bd73"

prometheus_version = "2.37.0"
thanos_version     = "0.34.1"