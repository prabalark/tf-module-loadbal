output "listener_arn" {
  value = aws_lb_listener.main.arn
}

output "dns_name1" {
  value = aws_lb.main.dns_name
}