provider "aws" {
  region = "${var.region}"
}

resource "aws_launch_configuration" "itau-test" {
  image_id        = "${var.ami}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${var.sg_loadbalancer}"]
  key_name        = "keypar-itau"
  user_data       = "${file("../user-data/bootstrap.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_metric_alarm" "cpualarm" {
  alarm_name          = "terraform-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = "itau-test"
  }

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.autopolicy.arn}"]
}

resource "aws_autoscaling_policy" "autopolicy-down" {
  name                   = "terraform-autoplicy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.scalegroup.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-down" {
  alarm_name          = "terraform-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.scalegroup.name}"
  }

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.autopolicy-down.arn}"]
}

resource "aws_elb" "elb1" {
  name               = "terraform-elb"
  availability_zones = "${var.availability_zones}"
  security_groups    = ["${var.sg_loadbalancer}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

}

resource "aws_lb_cookie_stickiness_policy" "cookie_stickness" {
  name                     = "cookiestickness"
  load_balancer            = "${aws_elb.elb1.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}

output "availabilityzones" {
  value = "${var.availability_zones}"
}

output "elb-dns" {
  value = "${aws_elb.elb1.dns_name}"
}