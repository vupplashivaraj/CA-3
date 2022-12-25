provider "aws" {
 region = "us-east-1"

}



resource "aws_s3_bucket" "b" {
  bucket = "sr-bucket"


  tags = {
    Name        = "sr bucket"
    Environment = "Dev"
  }
}
