resource "aws_launch_configuration" "nukegara" {
  name_prefix          = "${var.svc_name}-"
  image_id             = var.ec2_image_id
  instance_type        = var.ec2_instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs.id
  security_groups = [
    aws_security_group.ecs_instance_sg.id
  ]
  associate_public_ip_address = true
  user_data                   = base64encode(templatefile("user_data.sh", {}))

  ebs_block_device {
    device_name           = "/dev/xvdcz"
    volume_type           = "gp2"
    volume_size           = "22"
    delete_on_termination = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nukegara" {
  name                      = "${var.svc_name}-group"
  max_size                  = 1
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 0
  vpc_zone_identifier = [
    aws_default_subnet.default_a.id,
    aws_default_subnet.default_c.id,
  ]
  launch_configuration  = aws_launch_configuration.nukegara.id
  protect_from_scale_in = "true"

  tags = [
    {
      key                 = "Name"
      value               = "${var.svc_name}-node"
      propagate_at_launch = true
    },
    {
      key                 = "ClusterName"
      value               = "${var.svc_name}-ec2-cluster"
      propagate_at_launch = true
    },
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}
