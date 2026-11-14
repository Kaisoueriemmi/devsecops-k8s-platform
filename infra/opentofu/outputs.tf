output "printbox_bucket" {
  value = aws_s3_bucket.printbox.bucket
}

output "conversion_queue_url" {
  value = aws_sqs_queue.conversion.url
}

output "kms_key_id" {
  value = aws_kms_key.printbox.key_id
}
