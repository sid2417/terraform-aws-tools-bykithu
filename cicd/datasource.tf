data "aws_ami" "morrisons-ami" {
    most_recent = true
    owners = ["973714476881"]

    filter {
      name = "state"
      values = ["available"]
    }
    
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
  
}

data "aws_ami" "nexus_ami_info" {

    most_recent = true
    owners = ["679593333241"]

    filter {
        name   = "name"
        values = ["RHEL-9.4-RHCOS-4.18_HVM_GA-20250122-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

# data "aws_security_group" "sg_id" {
#     name = "kithusg"
#     description = "kithusg"
#     vpc_id = "vpc-0006516b9c09c69d5"
    
# }


# data "aws_subnet" "us_east_1a" {
#     id = "subnet-0d6a807fea42c52fb"
# }

# data "aws_vpc" "vpc_id" {
#     id = "vpc-0006516b9c09c69d5"
  
# }