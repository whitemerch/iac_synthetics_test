terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 604800
  receive_wait_time_seconds = 10
}

resource "aws_sqs_queue" "unencrypted_queue" {
  name                      = "iac-test-unencrypted-queue"
  delay_seconds             = local.delay_seconds
  max_message_size          = local.max_message_size
  message_retention_seconds = local.message_retention_seconds
  receive_wait_time_seconds = local.receive_wait_time_seconds

  # ❌ Intentionally misconfigured: SSE explicitly disabled
  sqs_managed_sse_enabled = false
}

output "queue_url" {
  value = aws_sqs_queue.unencrypted_queue.url
}
