data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

resource "aws_launch_template" "app" {
  name_prefix            = "webapp-lt-"
  image_id               = data.aws_ssm_parameter.al2023.insecure_value
  instance_type          = "t4g.micro"
  vpc_security_group_ids = [aws_security_group.app.id]
  user_data              = filebase64("${path.module}/user_data.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "webapp-app"
    }
  }
}