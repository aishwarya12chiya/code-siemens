resource "aws_subnet" "aws_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "aws_subnet"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route = []

  tags = {
    Name = "route_table"
  }
}
resource "aws_security_group" "security_group" {
  name_prefix = "security_group"
  vpc_id = aws_vpc.vpc.id
 
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
 
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  resource "aws_lambda_function" "lambda_function" {
    function_name    = "lambda_function"
    filename         = "lambda_function_payload.zip"
    source_code_hash = filebase64sha256("lambda_function_payload.zip")
    handler          = "index.handler"
    role             = aws_iam_role.lambda.arn
    runtime          = "nodejs14.x"
    vpc_config {
      subnet_ids = [aws_subnet.aws_subnet.id]
      security_group_ids = [aws_security_group.security_group.id]
    }
  }
