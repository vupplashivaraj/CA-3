resource "aws_security_group" "bastion-host134_SG" {
  name        = "bastion-host134_sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.sr-vpc.id

  ingress {
    description      = "ssh from bastion"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["49.43.42.187/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow ssh"
  }
}


resource "aws_security_group" "private_SG" {

 name        = "private_sg"
  description = "Allow all inbound traffic withn vpc"
  vpc_id      = aws_vpc.sr-vpc.id

  ingress {
    description      = "all traffic from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.sr-vpc.cidr_block]
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

resource "aws_security_group" "Public-web_SG" {
  name        = "Public-web_sg"
  description = "Allow port 80 form self ip"
  vpc_id      = aws_vpc.sr-vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["49.43.42.187/32"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow http"
  }
}
