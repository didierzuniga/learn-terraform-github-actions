terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    organization = "didierzuniga"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

provider "random" {}

resource "random_pet" "sg" {}

resource "aws_instance" "web" {
  ami                    = "ami-830c94e3"
  instance_type          = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!!!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}