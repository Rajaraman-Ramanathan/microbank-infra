data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.cluster_name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}