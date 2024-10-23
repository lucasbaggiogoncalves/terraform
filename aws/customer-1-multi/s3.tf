################################################################################
# EKS
################################################################################

resource "aws_s3_bucket" "s3-eks-01" {
  bucket = "${local.resource-prefix}-s3-eks-01"

  tags = var.tags
}