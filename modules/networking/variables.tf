variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "name" {
  default = "aiperi"
}


variable "public_subnet_cidr" {
  default = {
    us-east-1a = "10.0.1.0/24"
    us-east-1b = "10.0.2.0/24"
    us-east-1с = "10.0.3.0/24"
  }
}

variable "private_subnet_cidr" {
  type    = map(string)
  default = {
    us-east-1a = "10.0.11.0/24"
    us-east-1b = "10.0.22.0/24"
    us-east-1с = "10.0.33.0/24"
  }
}


variable "nat_subnet" {
  type    = string
  default = "us-east-1a" 
}


variable "private_subnet_cidr_block" {
  default = []
}
