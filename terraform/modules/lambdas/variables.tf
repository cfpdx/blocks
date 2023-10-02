variable "function_name" {
  description = "Name of the lambda function being defined"
  type = string
}

variable "filename" {
  description = "Name of the zipped file that defines the lambda"
  type = string
}

variable "description" {
  description = "The description of the lambda function being created"
  type = string
}

variable "handler" {
  description = "Functional entry point of lambda code"
  type = string
}

variable "runtime" {
  description = "The environment to run the lambda code"
  type = string
}

variable "api_source_arn" {
  description = "The source ARN of the API Gateway invoking the lambda"
  type = string
}