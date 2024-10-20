resource "aws_security_group" "sg" {
  name        = "${var.name}-alb-${var.env}-sg"
  description = "${var.name}-alb-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP" #in Load balancer we have HTTP or HTTPS
    from_port   = 80   # check in aws HTTP : 80 | HTTPS :443
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allow_alb_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-alb-${var.env}-sg" })
}

resource "aws_lb" "main" {
  name               = "${var.name}-alb-${var.env}"
  internal           = var.internal  # same flase we are giving in variable
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = var.subnets
  tags               = merge(var.tags, { Name = "${var.name}-alb-${var.env}" })
}

 # take arn & search in google ,
  # if no config we will get below 403 error
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Unauthorized"
      status_code  = "403"
    }
  }

}

