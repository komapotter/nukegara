Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash

# Install JQ JSON parser
yum install -y jq aws-cli

# Get the current region and instance_id from the instance metadata
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Install the SSM agent RPM
yum install -y https://amazon-ssm-$region.s3.amazonaws.com/latest/linux_amd64/amazon-ssm-agent.rpm

# Fetch ECS cluster name from tag
cluster_name=$(aws ec2 describe-instances --region $region --instance-ids $instance_id | jq '.Reservations[0].Instances[0].Tags | from_entries | .ClusterName' -r)

echo ECS_CLUSTER=$cluster_name >> /etc/ecs/ecs.config
echo ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"syslog\",\"fluentd\",\"awslogs\"] >> /etc/ecs/ecs.config
echo ECS_UPDATES_ENABLED=true >> /etc/ecs/ecs.config
echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1h >> /etc/ecs/ecs.config
echo ECS_CONTAINER_STOP_TIMEOUT=1m >> /etc/ecs/ecs.config

# EBS
mkfs -t ext4 /dev/xvdcz
mkdir -p /var/www/my-vol
mount /dev/xvdcz /var/www/my-vol
chmod 777 /var/www/my-vol

--==BOUNDARY==--
