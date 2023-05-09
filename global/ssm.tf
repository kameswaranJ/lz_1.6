# SSM role
resource "aws_iam_role" "ssm_instance" {
  provider = aws.app

  name                 = "role-${var.fq_name}-ssm"
  max_session_duration = 14400
  assume_role_policy   = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "SSMLoggingPolicy"

    #tfsec:ignore:aws-iam-no-policy-wildcards
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        # CloudWatch
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams"
          ],
          "Resource" : "*"
        },

        # S3
        #        {
        #          "Effect" : "Allow",
        #          "Action" : [
        #            "s3:PutObject"
        #          ],
        #          "Resource" : "arn:aws:s3:::DOC-EXAMPLE-BUCKET/s3-bucket-prefix/*"
        #        },
        #        {
        #          "Effect" : "Allow",
        #          "Action" : [
        #            "s3:GetEncryptionConfiguration"
        #          ],
        #          "Resource" : "*"
        #        },

        # Encryption
        #        {
        #          "Effect" : "Allow",
        #          "Action" : [
        #            "kms:Decrypt"
        #          ],
        #          "Resource" : "key-name"
        #        },
        #        {
        #          "Effect" : "Allow",
        #          "Action" : "kms:GenerateDataKey",
        #          "Resource" : "*"
        #        }
      ]
    })
  }
}

data "aws_iam_policy" "ssm_managed_instance_core" {
  provider = aws.app

  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  provider = aws.app

  role       = aws_iam_role.ssm_instance.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance_core.arn
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  provider = aws.app

  name = "ec2p-${var.fq_name}-ssm"
  role = aws_iam_role.ssm_instance.name
}
