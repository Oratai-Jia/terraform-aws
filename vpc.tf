resource "aws_vpc" "main" {
    cidr_block = "10.66.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "Main VPC"
    }
}

resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "Main Gateway"
    }
}

resource "aws_subnet" "public-2a" {
    vpc_id = "${aws_vpc.main.id}"

    cidr_block = "10.66.1.0/24"
    availability_zone = "us-east-2a"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }

    tags {
        Name = "Public Route Table"
    }
}

resource "aws_route_table_association" "public-2a" {
    subnet_id = "${aws_subnet.public-2a.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_subnet" "private-2a" {
    vpc_id = "${aws_vpc.main.id}"

    cidr_block = "10.66.2.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-2a"

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_eip" "nat" {
    vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.public-2a.id}"
    depends_on = [aws_internet_gateway.main-gw]
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_nat_gateway.nat-gw.id}"
    }

    tags {
        Name = "Private Route Table"
    }
}

resource "aws_route_table_association" "private-2a" {
    subnet_id = "${aws_subnet.private-2a.id}"
    route_table_id = "${aws_route_table.private.id}"
}
