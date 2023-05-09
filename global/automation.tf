#tfsec:ignore:aws-iam-no-user-attached-policies
resource "aws_iam_user" "automation" {
  #checkov:skip=CKV_AWS_273:This user is required for project team automation tools
  provider      = aws.deploy
  name          = "user-${var.fq_name}-automation-${var.uniqueness_suffix}"
  force_destroy = true
}

# Project secret key
resource "aws_iam_access_key" "automation" {
  provider = aws.deploy
  user     = aws_iam_user.automation.name
}

# Put credentials in secret manager
#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "automation" {
  #checkov:skip=CKV_AWS_149:TODO setup KMS encryption
  #checkov:skip=CKV2_AWS_57:TODO setup secret/key rotation
  provider = aws.app

  name                    = "/lz/credentials/user-${var.fq_name}-automation"
  recovery_window_in_days = 0

  dynamic "replica" {
    for_each = var.secret_regions

    content {
      region = replica.value
    }
  }
}

resource "aws_secretsmanager_secret_version" "automation" {
  provider      = aws.app
  secret_id     = aws_secretsmanager_secret.automation.id
  secret_string = jsonencode({
    AWS_ACCESS_KEY_ID     = aws_iam_access_key.automation.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.automation.secret
    AWS_ROLE_ARN          = aws_iam_role.automation.arn
  })
}

# The user can assume any role (but only in the app account)
resource "aws_iam_user_policy" "automation" {
  #checkov:skip=CKV_AWS_40:This is a trust policy
  provider = aws.deploy

  name = "AssumableRoles"
  user = aws_iam_user.automation.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow"
        "Action" : "sts:AssumeRole",
        "Resource" : aws_iam_role.automation.arn
      }
    ]
  })
}

resource "aws_iam_role" "automation" {
  provider = aws.app

  name                 = "role-${var.fq_name}-automation"
  max_session_duration = 14400
  assume_role_policy   = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow"
        Principal = {
          AWS = aws_iam_user.automation.arn
        }
      }
    ]
  })

  inline_policy {
    name   = "IAMRoleManagement"
    policy = file("${path.module}/../policies/ps/stla-standard-access.json")
  }
}

data "aws_iam_policy" "aws_backup_operator_access" {
  provider = aws.app

  name = "AWSBackupOperatorAccess"
}

resource "aws_iam_role_policy_attachment" "aws_backup_operator_access" {
  provider = aws.app

  role       = aws_iam_role.automation.name
  policy_arn = data.aws_iam_policy.aws_backup_operator_access.arn
}
