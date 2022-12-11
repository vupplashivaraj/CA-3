provider "aws" {
region     = "us-east-1"
}


# ---  Creating a VPC ------


resource "aws_vpc" "sr-vpc" {
  cidr_block       = "10.10.0.0/16"
  tags = {
    Name = "srvpc"
  }
}



#--- Creating Internet Gateway


resource "aws_internet_gateway" "sr-igw" {
 vpc_id = "${aws_vpc.sr.id}"
 tags = {
    Name = "sr-igw"
 }
}


# - Creating Elastic IP


resource "aws_eip" "sr-eip" {
  vpc=true
}

# -- Creating Subnet


data "aws_availability_zones" "sr-azs" {
  state = "available"
}



        #  creating public subnet


resource "aws_subnet" "sr-public-subnet-1a" {
  availability_zone = "${data.aws_availability_zones.sr-azs.names[0]}"
  cidr_block        = "10.10.20.0/24"
  vpc_id            = "${aws_vpc.sr-vpc.id}"
  map_public_ip_on_launch = "true"
  tags = {
   Name = "sr-public-subnet-1a"
   }
}

resource "aws_subnet" "sr-public-subnet-1b" {
  availability_zone = "${data.aws_availability_zones.sr-azs.names[1]}"
  cidr_block        = "10.10.21.0/24"
  vpc_id            = "${aws_vpc.sr-vpc.id}"
  map_public_ip_on_launch = "true"
  tags = {
   Name = "sr-public-subnet-1b"
   }
}


        #  Creating  private subnet


resource "aws_subnet" "sr-private-subnet-1a" {
  availability_zone = "${data.aws_availability_zones.sr-azs.names[0]}"
  cidr_block        = "10.10.30.0/24"
  vpc_id            = "${aws_vpc.sr-vpc.id}"
  tags = {
   Name = "sr-private-subnet-1a"
   }
}


resource "aws_subnet" "sr-private-subnet-1b" {
  availability_zone = "${data.aws_availability_zones.sr-azs.names[1]}"
  cidr_block        = "10.10.31.0/24"
  vpc_id            = "${aws_vpc.sr-vpc.id}"
  tags = {
   Name = "sr-private-subnet-1b"
   }
}





# --------------  NAT Gateway

resource "aws_nat_gateway" "sr-ngw" {
  allosrtion_id = "${aws_eip.sr-eip.id}"
  subnet_id = "${aws_subnet.sr-public-subnet-1b.id}"
  tags = {
      Name = "sr-Nat Gateway"
  }
}




# ------------------- Routing ----------


resource "aws_route_table" "sr-public-route" {
  vpc_id =  "${aws_vpc.sr-vpc.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.sr-igw.id}"
  }

   tags = {
       Name = "sr-public-route"
   }
}


resource "aws_default_route_table" "sr-private-route" {
  private_route_table_id = "${aws_vpc.sr.private_route_table_id}" 
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.sr-igw.id}"
  }
  
  
  tags = {
      Name = "sr-default-route"
  }
}



#--- Subnet Association -----

resource "aws_route_table_association" "sr-1a" {
  subnet_id = "${aws_subnet.sr-public-subnet-1a.id}"
  route_table_id = "${aws_route_table.sr-public-route.id}"
}


resource "aws_route_table_association" "sr-1b" {
  subnet_id = "${aws_subnet.sr-public-subnet-1b.id}"
  route_table_id = "${aws_route_table.sr-public-route.id}"
}


resource "aws_route_table_association" "sr-p-1a" {
  subnet_id = "${aws_subnet.sr-private-subnet-1a.id}"
  route_table_id = "${aws_vpc.sr-vpc.default_route_table_id}"
}

resource "aws_route_table_association" "sr-p-1b" {
  subnet_id = "${aws_subnet.sr-private-subnet-1b.id}"
  route_table_id = "${aws_vpc.sr-vpc.default_route_table_id}"
}
