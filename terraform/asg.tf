resource "aws_autoscaling_group" "scalegroup" {
  launch_configuration = "${aws_launch_configuration.itau-test.name}"
  availability_zones   = "${var.availability_zones}"
  min_size             = REPLICAS
  max_size             = REPLI_MAX
  enabled_metrics      = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
  metrics_granularity  = "1Minute"
  load_balancers       = ["${aws_elb.elb1.id}"]
  health_check_type    = "ELB"
  
  tag {
    key                 = "Name"
    value               = "webserver000"
    propagate_at_launch = true
  }
}

resource "aws_cloudformation_stack" "scalegroup" {
  name = "${var.cfn_stack_name}"
 
  template_body = <<EOF
Description: "${var.cfn_stack_description}"
Resources:
  ASG:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      VPCZoneIdentifier: ["${join("\",\"", var.subnets)}"]
      AvailabilityZones: ["${join("\",\"", var.availability_zones)}"]
      LaunchConfigurationName: "${aws_launch_configuration.ecs.name}"
      MinSize: "${var.asg_min_size}"
      MaxSize: "${var.asg_max_size}"
      DesiredCapacity: "${var.asg_desired_capacity}"
      HealthCheckType: EC2
 
    CreationPolicy:
      AutoScalingCreationPolicy:
        MinSuccessfulInstancesPercent: 80
      ResourceSignal:
        Count: "${var.cfn_signal_count}"
        Timeout: PT10M
    UpdatePolicy:
    # Ignore differences in group size properties caused by scheduled actions
      AutoScalingScheduledAction:
        IgnoreUnmodifiedGroupSizeProperties: true
      AutoScalingRollingUpdate:
        MaxBatchSize: "${var.asg_max_size}"
        MinInstancesInService: "${var.asg_min_size}"
        MinSuccessfulInstancesPercent: 80
        PauseTime: PT10M
        SuspendProcesses:
          - HealthCheck
          - ReplaceUnhealthy
          - AZRebalance
          - AlarmNotification
          - ScheduledActions
        WaitOnResourceSignals: true
    DeletionPolicy: Retain
  EOF

  tag {
    key                 = "Name"
    value               = "webserver000"
  }
}