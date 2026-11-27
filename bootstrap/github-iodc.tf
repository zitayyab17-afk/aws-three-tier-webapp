import {
  to = aws_iam_openid_connect_provider.github
  id = "arn:aws:iam::292759875405:oidc-provider/token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  tags = {
    Name = "github-actions-oidc"
  }
}

resource "aws_iam_role" "github_action" {
  name = "webapp-github-action"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:zitayyab17-afk@238903574/aws-three-tier-webapp@1437764613:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    Name = "webapp-github-action"
  }
}

resource "aws_iam_role_policy_attachment" "github_action_admin" {
  role       = aws_iam_role.github_action.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}