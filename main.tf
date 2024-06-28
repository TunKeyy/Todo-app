provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = file("~/.ssh/my-key-pair.pub")
}

resource "aws_security_group" "allow_ssh_http" {
  name = "allow_ssh_http"
  description = "Allow SSH and HTTP traffic"

  ingress  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "react_app" {
  ami           = "ami-0be48b687295f8bd6"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "ReactAppInstance"
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "docker --version"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/my-key-pair.pem")
      host        = self.public_ip
    }
  }
}