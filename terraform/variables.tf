variable "region" {
  description = "AWS Region"
  default     = "sa-east-1"
}

variable "key_path" {
  description = "Public key path"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ami" {
  description = "AMI"
  default     = "ami-80086dec" // Amazon Linux
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "availability_zones" {
  default = ["sa-east-1a","sa-east-1b","sa-east-1c"]
}

variable "asg_min_size" {
  default = "2"
}

variable "asg_max_size" {
  default = "6"
}

variable "asg_desired_capacity" {
  default = "2"
}

variable "private-subnet"{
  default = ["subnet-0b7adb20d3d934993", "subnet-0ab18e2c4fce31174"]
}

variable "public-subnets" {
  default = "subnet-0f85f00e46ac18e76"
}

variable "vpc_id" {
  default = "vpc-06ff555b7f6cb853a"
}

variable "sg_loadbalancer" {
 default = "sg-048c86c6342ca9942"
}

data "aws_ami" "ec2-linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "instance_class" {
  default     = "db.t2.micro"
  description = "Instance class"
}


variable "cfn_stack_name" {
  default     = "itau-test"
}

variable "cfn_stack_description" {
  default     = "itau-test"
}

