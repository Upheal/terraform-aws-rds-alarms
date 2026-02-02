terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

// CPU Utilization
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count               = var.create_high_cpu_alarm ? 1 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-highCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.cpu_utilization_too_high_threshold
  alarm_description   = "Average database CPU utilization is too high."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance_too_low" {
  count               = var.create_low_cpu_credit_alarm ? length(regexall("(t2|t3|t4g)", var.db_instance_class)) > 0 ? 1 : 0 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-lowCPUCreditBalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.cpu_credit_balance_too_low_threshold
  alarm_description   = "Average database CPU credit balance is too low, a negative performance impact is imminent."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}

// Disk Utilization
resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
  count               = var.create_high_queue_depth_alarm ? 1 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-highDiskQueueDepth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.disk_queue_depth_too_high_threshold
  alarm_description   = "Average database disk queue depth is too high, performance may be negatively impacted."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "disk_free_storage_space_too_low" {
  count               = var.create_low_disk_space_alarm ? 1 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-lowFreeStorageSpace"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.disk_free_storage_space_too_low_threshold
  alarm_description   = "Average database free storage space is too low and may fill up soon."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "disk_burst_balance_too_low" {
  count               = var.create_low_disk_burst_alarm ? 1 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-lowEBSBurstBalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.disk_burst_balance_too_low_threshold
  alarm_description   = "Average database storage burst balance is too low, a negative performance impact is imminent."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "ebs_io_balance_warn" {
  count               = var.create_ebs_io_balance_alarm ? 1 : 0
  alarm_name          = "WARN: ${var.prefix}rds-${var.db_instance_id}-EBSIOBalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "EBSIOBalance%"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.ebs_io_balance_warn_threshold
  alarm_description   = "EBS IO balance is below warning threshold, I/O credits are being consumed."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "ebs_io_balance_crit" {
  count               = var.create_ebs_io_balance_alarm ? 1 : 0
  alarm_name          = "CRIT: ${var.prefix}rds-${var.db_instance_id}-EBSIOBalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "EBSIOBalance%"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.ebs_io_balance_crit_threshold
  alarm_description   = "EBS IO balance is critically low, I/O performance degradation is imminent."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "ebs_byte_balance_warn" {
  count               = var.create_ebs_byte_balance_alarm ? 1 : 0
  alarm_name          = "WARN: ${var.prefix}rds-${var.db_instance_id}-EBSByteBalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "EBSByteBalance%"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.ebs_byte_balance_warn_threshold
  alarm_description   = "EBS byte balance is below warning threshold, throughput credits are being consumed."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "ebs_byte_balance_crit" {
  count               = var.create_ebs_byte_balance_alarm ? 1 : 0
  alarm_name          = "CRIT: ${var.prefix}rds-${var.db_instance_id}-EBSByteBalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "EBSByteBalance%"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.ebs_byte_balance_crit_threshold
  alarm_description   = "EBS byte balance is critically low, throughput performance degradation is imminent."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}


// Memory Utilization
resource "aws_cloudwatch_metric_alarm" "memory_freeable_too_low" {
  count               = var.create_low_memory_alarm ? 1 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-lowFreeableMemory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.memory_freeable_too_low_threshold
  alarm_description   = "Average database freeable memory is too low, performance may be negatively impacted."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "memory_swap_usage_too_high" {
  count               = var.create_swap_alarm ? 1 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-highSwapUsage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "SwapUsage"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.memory_swap_usage_too_high_threshold
  alarm_description   = "Average database swap usage is too high, performance may be negatively impacted."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  tags = var.tags
}

// Connection Count
resource "aws_cloudwatch_metric_alarm" "connection_count_anomalous" {
  count               = var.create_anomaly_alarm ? 1 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-anomalousConnectionCount"
  comparison_operator = "GreaterThanUpperThreshold"
  evaluation_periods  = var.evaluation_period
  threshold_metric_id = "e1"
  alarm_description   = "Anomalous database connection count detected. Something unusual is happening."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1, ${var.anomaly_band_width})"
    label       = "DatabaseConnections (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DatabaseConnections"
      namespace   = "AWS/RDS"
      period      = var.anomaly_period
      stat        = "Average"
      unit        = "Count"

      dimensions = {
        DBInstanceIdentifier = var.db_instance_id
      }
    }
  }
  tags = var.tags
}

// [postgres, aurora-postgres] Early Warning System for Transaction ID Wraparound
// more info - https://aws.amazon.com/blogs/database/implement-an-early-warning-system-for-transaction-id-wraparound-in-amazon-rds-for-postgresql/
resource "aws_cloudwatch_metric_alarm" "maximum_used_transaction_ids_too_high" {
  count               = contains(["aurora-postgresql", "postgres"], var.engine) ? 1 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-maximumUsedTransactionIDs"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "MaximumUsedTransactionIDs"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.maximum_used_transaction_ids_too_high_threshold
  alarm_description   = "Nearing a possible critical transaction ID wraparound."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

# SOC2 requirements
resource "aws_cloudwatch_metric_alarm" "read_iops_too_high" {
  count               = var.create_read_iops_alarm ? 1 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-read-iops-too-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "ReadIOPS"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.read_iops_too_high_threshold
  alarm_description   = "Average Read IO over last ${(var.evaluation_period * var.statistic_period / 60)} minutes too high, performance may suffer"
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "write_iops_too_high" {
  count               = var.create_write_iops_alarm ? 1 : 0
  alarm_name          = "${var.prefix}rds-${var.db_instance_id}-write-iops-too-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "WriteIOPS"
  namespace           = "AWS/RDS"
  period              = var.statistic_period
  statistic           = "Average"
  threshold           = var.write_iops_too_high_threshold
  alarm_description   = "Average Write IO over last ${(var.evaluation_period * var.statistic_period / 60)} minutes too high, performance may suffer"
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "low_database_connections" {
  alarm_name          = "${var.prefix}-ec2-${var.db_instance_id}-lowDatabaseConnections"
  metric_name         = "DatabaseConnections"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/RDS"
  statistic           = "Average"
  evaluation_periods  = 2
  period              = 60
  threshold           = var.low_database_connections_threshold
  alarm_description   = "Average database connections are low, indicating the database is not in use."
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  tags = var.tags

  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "ebs_byte_balance_alarm" {
  alarm_name        = "${var.prefix}-rds-${var.db_instance_id}-EBSLowByteBalanceAlarm"
  alarm_description = "RDS EBS byte balance alarm. Triggers when EBS byte balance is less than threshold"
  namespace         = "AWS/RDS"
  metric_name       = "EBSByteBalance"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.ebs_byte_balance_too_low_threshold
  comparison_operator = "LessThanThreshold"
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok
  treat_missing_data  = "notBreaching"
}
