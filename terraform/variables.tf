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

variable "cfn_stack_description" {
  default = "itau-test"
}


