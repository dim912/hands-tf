terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
     version = "4.51.0"
   }
 }
}

provider "aws" {
  alias = "asia"
  region = "ap-southeast-1"
}

