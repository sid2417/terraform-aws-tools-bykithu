module "jenkins" {
  
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-tf"

  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-0105d582eadabe91b"]
  subnet_id     = "subnet-0d6a807fea42c52fb"
  ami = data.aws_ami.morrisons-ami.id
  user_data = file("jenkins.sh")

  tags = { 
    Name = "jenkins-tf"
    }
}



module "jenkins_agent" {
  
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-agent"

  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-0105d582eadabe91b"]
  subnet_id     = "subnet-0d6a807fea42c52fb"
  ami = data.aws_ami.morrisons-ami.id
  user_data = file("jenkins-agent.sh")

  tags = { 
    Name = "jenkins-agent"
    }
}


resource "aws_key_pair" "nexus_key" {
  key_name   = "nexus_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINeelAjMydoP8yg8nQplhvyrY2nykihsdbyjVn3eAI2Q SIDDHARTHA@LAPTOP-HJASD3HA"
} 


module "nexus" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "nexus"

  instance_type          = "t3.medium"
  vpc_security_group_ids = ["sg-0105d582eadabe91b"]
  subnet_id = "subnet-0d6a807fea42c52fb"
  ami = data.aws_ami.nexus_ami_info.id
  key_name = aws_key_pair.nexus_key.key_name
  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 30
    }
  ]
  tags = {
    Name = "nexus"
  }
}



module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name  # this is parent-domain

  records = [
    {
      name    = "jenkins"  # this is considered as sub-domain
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins.public_ip
        
      ]
      allow_overwrite = true
      
    },
    {
      name    = "jenkins-agent"  # this is considered as sub-domain
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins_agent.private_ip
        
      ]
      allow_overwrite = true
      
    },
    {
      name    = "nexus"  # this is considered as sub-domain
      type    = "A"
      ttl     = 1
      records = [
        module.nexus.private_ip
        
      ]
      allow_overwrite = true
      
    }
  ]
}