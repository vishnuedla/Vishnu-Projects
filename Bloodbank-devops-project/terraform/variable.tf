variable "cidr_vpc_A" {
  type = string
}

variable "cidr_vpc_B" {
  type = string
}

variable "cidr_vpc_C" {
  type = string
}


variable "subnet_cidr_vpc_A" {
  type = string
  
}


variable "subnet_cidr_vpc_B" {
  type = string
  
}


variable "subnet_cidr_vpc_c1" {
  type = string
  
}


variable "subnet_cidr_vpc_c2" {
  type = string

}

variable "subnet_cidr_vpc_c3" {
  type = string
  
}


variable "ami" {
 
  type = string
  default = "ami-05d2d839d4f73aafb"
}


variable "instance_type" {
 
  type = string
}

variable "key" {
  
  type = string
}
