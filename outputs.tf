#output "dns_name" {
#  value = aws_lb.main.dns_name
#}

output "listener_arn" {
  value = aws_lb_listener_rule.rule.arn
}