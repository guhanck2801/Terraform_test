#-----------------------------------

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      //version = "~> 6.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-2"
  access_key = ""
  secret_key = ""
}


#------------------------------------

 
resource "aws_s3_bucket" "guhan-tf-test-bucket" {
  bucket = "guhan-tf1"
}

resource "aws_s3_object" "guhan-tf-test-unprocessed" {
  bucket = aws_s3_bucket.guhan-tf-test-bucket.id
  key    = "unprocessed/"
}

resource "aws_s3_object" "guhan-tf-test-processed" {
  bucket = aws_s3_bucket.guhan-tf-test-bucket.id
  key    = "processed/"
}


#------------------------------------


resource "aws_lambda_function" "example" {
  filename      = "lambda/file_move_lambda.zip"
  function_name = "guhan_move_file"
  role          = "arn:aws:iam::126454579138:role/S3FullAccessRole"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.14"

}
