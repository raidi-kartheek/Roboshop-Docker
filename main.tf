resource "aws_instance" "docker" {
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.small"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id = "subnet-04289ebfb0c45dc5f" #replace your Subnet in default VPC

  # need more for terraform
  root_block_device {
    volume_size = 80
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("docker.sh")
#   tags {
#     name= "docker"
#   }

}
 resource "aws_security_group" "allow_ssh" {

  name = "allow-ssh"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Docker App"

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Application"

    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}