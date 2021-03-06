provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_security_group" "ssh_and_http" {
  name = "allow_ssh_and_http"
  description = "Allow SSH and HTTP traffic"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 443
      to_port = 443
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_master" {
    ami = "ami-07a3bd4944eb120a0"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.ssh_and_http.name}"]

    tags {
        Name = "jenkins_master"
        role = "jenkins_master"
    }
}

resource "aws_eip" "jenkins_master" {
    instance = "${aws_instance.jenkins_master.id}"
    vpc = true
}