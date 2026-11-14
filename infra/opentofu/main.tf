# Ressources cloud émulées de la phase v1 (INF-02).

resource "aws_kms_key" "printbox" {
  description = "Cle de chiffrement PrintBox (Floci)"
}

resource "aws_s3_bucket" "printbox" {
  bucket = var.printbox_bucket
}

resource "aws_s3_bucket_versioning" "printbox" {
  bucket = aws_s3_bucket.printbox.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "printbox" {
  bucket                  = aws_s3_bucket.printbox.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_sqs_queue" "conversion_dlq" {
  name = "printbox-conversion-dlq"
}

resource "aws_sqs_queue" "conversion" {
  name = "printbox-conversion"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.conversion_dlq.arn
    maxReceiveCount     = 5
  })
}

# Rôle de l'api : accès limité à son bucket (moindre privilège).
data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "printbox_s3" {
  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.printbox.arn}/*"]
  }
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.printbox.arn]
  }
}

resource "aws_iam_role" "printbox_api" {
  name               = "printbox-api"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy" "printbox_s3" {
  name   = "printbox-s3"
  role   = aws_iam_role.printbox_api.id
  policy = data.aws_iam_policy_document.printbox_s3.json
}
