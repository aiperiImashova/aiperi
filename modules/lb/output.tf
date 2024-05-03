output "igw_id" {
  value = aws_lb.alb.id
}
output "tg_arn" {
  value = aws_lb_target_group.tg.arn
}