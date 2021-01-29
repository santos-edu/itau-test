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