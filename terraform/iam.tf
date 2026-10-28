resource "aws_iam_role" "ec2" {
  name = "webapp-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "webapp-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "webapp-ec2-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_iam_role_policy" "ec2_read_db_secret" {
  name = "webapp-read-db-secret"
  role = aws_iam_role.ec2.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect   = "Allow"
        Resource = aws_db_instance.main.master_user_secret[0].secret_arn
      }
    ]
  })
}