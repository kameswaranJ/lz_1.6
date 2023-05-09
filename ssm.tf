#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "ssm" {
  #checkov:skip=CKV_AWS_158:TODO setup KMS encryption
  provider = aws.app

  name              = "/stla/ssm-sessions/${local.fq_name}"
  retention_in_days = 30
}

# FIXME: hack to update ssm prefs
resource "null_resource" "ssm_prefs_deletion" {
  provisioner "local-exec" {
    command = "${path.module}/ssm_delete_prefs.sh ${data.aws_region.current.id} ${var.app_role}"
  }
}

resource "aws_ssm_document" "session_manager_prefs" {
  provider   = aws.app
  depends_on = [null_resource.ssm_prefs_deletion]

  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to hold regional settings for Session Manager"
    sessionType   = "Standard_Stream"
    inputs        = {
      cloudWatchLogGroupName      = aws_cloudwatch_log_group.ssm.name
      cloudWatchEncryptionEnabled = false
      cloudWatchStreamingEnabled  = true
      idleSessionTimeout          = 20
      maxSessionDuration          = null # no max
    }
  })
}

moved {
  from = aws_iam_role.ssm_instance
  to   = module.global[0].aws_iam_role.ssm_instance
}

moved {
  from = aws_iam_role_policy_attachment.ssm_managed_instance_core
  to   = module.global[0].aws_iam_role_policy_attachment.ssm_managed_instance_core
}

moved {
  from = aws_iam_instance_profile.ssm_instance_profile
  to   = module.global[0].aws_iam_instance_profile.ssm_instance_profile
}
