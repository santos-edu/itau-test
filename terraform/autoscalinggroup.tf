resource "aws_autoscaling_group" "scalegroup" {
  launch_configuration = "${aws_launch_configuration.itau-test.name}"
  availability_zones   = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
  min_size             = REPLICAS
  max_size             = REPLI_MAX
  desired_capacity     = REPLICAS_DESIRED
  enabled_metrics      = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
  metrics_granularity  = "1Minute"
  load_balancers       = ["${aws_elb.elb1.id}"]
  health_check_type    = "ELB"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "webserver000"
    propagate_at_launch = true
  }
}