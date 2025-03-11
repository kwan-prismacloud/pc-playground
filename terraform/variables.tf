variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "static_website_s3_bucket_prefix" {
  type        = string
  description = "Prefix for the S3 bucket which hosts static website. Must be lower case and fewer than 38 characters in length."
}


variable "static_website_s3_bucket_tags" {
  type        = map
  description = "tags for the S3 bucket which hosts static website."
}