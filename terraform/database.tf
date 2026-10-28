resource "aws_db_subnet_group" "main" {
  name       = "webapp-db-subnet-group"
  subnet_ids = [aws_subnet.db_a.id, aws_subnet.db_b.id]

  tags = {
    Name = "webapp-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier                  = "webapp-db"
  engine                      = "postgres"
  engine_version              = "17"
  instance_class              = "db.t4g.micro"
  allocated_storage           = 20
  storage_type                = "gp3"
  db_name                     = "webappdb"
  username                    = "webappadmin"
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.main.name
  vpc_security_group_ids      = [aws_security_group.db.id]
  publicly_accessible         = false
  multi_az                    = false
  skip_final_snapshot         = true
  storage_encrypted           = true
  backup_retention_period     = 1
  deletion_protection         = false

  tags = {
    Name = "webapp-db"
  }
}