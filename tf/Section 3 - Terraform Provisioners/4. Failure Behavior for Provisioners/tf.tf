//if creation time prvisioner fails -- rsouces is marked as tainted.
//to change above behavior --> can use "on_failure" property of provisioner can be used

provider "aws" {
  region     = "ap-southeast-1"
  access_key = "YOUR-KEY"
  secret_key = "YOUR-KEY"
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH into VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myec2" {
  ami = "ami-0b1e534a4ff9019e0"
  instance_type = "t2.micro"
  key_name = "ec2-key"
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]

  provisioner "remote-exec" {
    on_failure = continue  // continue==> ignore error and continue, fail ==> raise an error and stop applying. if this is creation provisioner, taint the resource
    inline = [
      "sudo yum -y install nano"
    ]
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("./ec2-key.pem")
    host = self.public_ip
  }
}