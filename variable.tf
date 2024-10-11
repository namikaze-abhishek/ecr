variable "environment" {
  description = "The environment to deploy to (development or productions)"
  type        = string
}

variable "image_tag" {
  description = "The Docker image tag to deploy"
  type        = string
}

variable "pr_id" {
  description = "Pull request ID for dynamic service creation"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The VPC ID where ECS cluster will be created"
  type        = string
  default     = "vpc-0961ac8c005e5648d"

}

variable "subnets" {
  description = "The subnets where ECS services will be deployed"
  type        = list(string)
  default     = ["subnet-07f2c582e8c97547a", "subnet-022f0cfe370f1d385"]

}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

