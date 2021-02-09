resource "aws_instance" "web" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-east-2a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.public-2a.id}"
    associate_public_ip_address = true
    source_dest_check = false


    tags {
        Name = "Web Server"
    }
}

resource "aws_instance" "db" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-east-2a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]
    subnet_id = "${aws_subnet.private-2a.id}"
    source_dest_check = false

    tags {
        Name = "DB Server"
    }
}
