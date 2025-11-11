# ===================================
# S3 BUCKET PARA HOSTING ESTÁTICO
# ===================================

resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-frontend-${var.environment}"
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Política do bucket para permitir acesso público aos objetos
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend]


}
#parte adicionada 30/09
# ===================================
# S3 BUCKET
# ===================================
resource "aws_s3_bucket" "meu_bucket" {
  bucket = "aulaaws-${var.project_name}-bucket-${var.environment}"
}

resource "aws_s3_bucket_versioning" "meu_bucket" {
  bucket = aws_s3_bucket.meu_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ===================================
# DYNAMODB 
# ===================================
resource "aws_dynamodb_table" "minha_tabela" {
  name         = "aulaaws-${var.project_name}-tabela-${var.environment}"
  billing_mode = "PAY_PER_REQUEST" 

  # chave primária
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "aulaaws-${var.project_name}-tabela"
    Environment = var.environment
  }
}
