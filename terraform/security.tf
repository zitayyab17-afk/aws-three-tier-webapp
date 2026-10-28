resource "aws_security_group" "alb" {
  name        = "webapp-alb-sg"
  description = "Allow HTTP from internet to the loadbalancer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "webapp-alb-sg"
  }
}

resource "aws_security_group" "app" {
  name        = "webapp-app-sg"
  description = "Allow HTTP from loadbalancer to web server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "webapp-app-sg"
  }
}

resource "aws_security_group" "db" {
  name        = "webapp-db-sg"
  description = "Allow Postgresql from web servers to the database"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "webapp-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "app_http_from_alb" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "db_postgres_from_app" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id = aws_security_group.alb.id

  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.db.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

resource "aws_vpc_security_group_egress_rule" "app_https_out" {
  security_group_id = aws_security_group.app.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}
