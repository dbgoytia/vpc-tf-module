################################################################################
# Flow Log
################################################################################
resource "aws_flow_log" "this" {
  count                    = var.enable_flow_log ? 1 : 0
  log_destination_type     = var.log_destination_type
  log_destination          = var.log_destination
  traffic_type             = var.traffic_type
  vpc_id                   = aws_vpc.this.id
  max_aggregation_interval = var.max_aggregation_interval
}