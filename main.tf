provider "aws" {
  region = "us-east-1"

}
#VPC
resource "aws_vpc" "G4_VPC" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name = "Group4-VPC"
    }
}
#InternetGateway for the VPC
resource "aws_internet_gateway" "G4_IGW" {
    vpc_id = aws_vpc.G4_VPC.id

    tags = {
      name = "Group4-IGW"
    }
}

resource "aws_route_table" "G4_RT" {
    vpc_id = aws_vpc.G4_VPC.id

    tags = {
      name = "Group4-IGW"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.G4_IGW.id
    }
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.G4_IGW.id
    }
}
#Subnet
resource "aws_subnet" "G4_Subnet" {
    vpc_id = aws_vpc.G4_VPC.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    depends_on = [ aws_internet_gateway.G4_IGW ]
    tags = {
      name = "Group4-Subnet"
    }
}
#Associate Subnet with route table
resource "aws_route_table_association" "G4_RT_to_Subnet" {
    subnet_id = aws_subnet.G4_Subnet.id
    route_table_id = aws_route_table.G4_RT.id

}
#Security Group
resource "aws_security_group" "G4_SG" {
    name = "Group4-SecurityGroup"
    description = "Allow SSH, HTTP, HTTPS inbound traffic"
    vpc_id = aws_vpc.G4_VPC.id
    
    ingress {
        description = "SSH from VPC"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTPS from VPC"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      name = "Group4-SecurityGroup"
    }
}
#EC2 Instance
resource "aws_instance" "G4_Instance" {
    
    ami = "ami-012485deee5681dc0"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.G4_Subnet.id
    vpc_security_group_ids = [aws_security_group.G4_SG.id]
    tags = {
      Name = "Group4-Instance1"
    }
}

