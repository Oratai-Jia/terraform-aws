variable "aws_access_key" {
    default = "ACCESS"
}
variable "aws_secret_key" {
    default = "SECRET"
}
variable "aws_key_path" {
    default = "/root/terraform"
}
variable "aws_key_name" {
    default = "keyPair"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-2"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-2 = "ami-0996d3051b72b5b2c"
    }
}
