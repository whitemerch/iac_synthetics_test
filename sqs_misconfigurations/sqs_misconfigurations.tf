terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "queues" {
  description = "Queue names to create or import (unencrypted on apply)."
  type        = map(string)
  default     = {"queue-a": "iac-misconfig-queue-a", "queue-b": "iac-misconfig-queue-b"}
}

locals {
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 604800
  receive_wait_time_seconds = 10
}

# Optional: import existing queues with these names (Terraform 1.5+)
# Comment out this block if you only want to create new queues.
# import {
#   for_each = var.queues
#   id       = "https://sqs.us-east-1.amazonaws.com/486234852809/${each.value}"
#   to       = aws_sqs_queue.sqs_queues[each.value]
# }

resource "aws_sqs_queue" "sqs_queues" {
  for_each = var.queues

  name                      = each.value
  delay_seconds             = local.delay_seconds
  max_message_size          = local.max_message_size
  message_retention_seconds = local.message_retention_seconds
  receive_wait_time_seconds = local.receive_wait_time_seconds

  # ❌ Intentionally misconfigured: SSE explicitly disabled
  sqs_managed_sse_enabled = false
}

output "queue_urls" {
  value = { for k, q in aws_sqs_queue.sqs_queues : k => q.url }
}
