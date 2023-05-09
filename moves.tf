# Renaming of modules for tflink
moved {
  from = module.onprem-ext-shared
  to = module.onprem_ext_shared
}

moved {
  from = module.onprem-ext-dedicated
  to = module.onprem_ext_dedicated
}

# Moves of global resources (exclusive with similar very old moves in CLI)

moved {
  from = aws_iam_user.automation
  to   = module.global[0].aws_iam_user.automation
}

moved {
  from = aws_iam_user_policy.automation
  to   = module.global[0].aws_iam_user_policy.automation
}

moved {
  from = aws_iam_role.automation
  to   = module.global[0].aws_iam_role.automation
}

moved {
  from = aws_iam_role_policy_attachment.power_user
  to   = module.global[0].aws_iam_role_policy_attachment.power_user
}

moved {
  from = aws_iam_access_key.automation
  to   = module.global[0].aws_iam_access_key.automation
}

moved {
  from = aws_secretsmanager_secret.automation
  to   = module.global[0].aws_secretsmanager_secret.automation
}

moved {
  from = aws_secretsmanager_secret_version.automation
  to   = module.global[0].aws_secretsmanager_secret_version.automation
}

# Refactor into three network models

## Uncomment if migrating from pre 2.x dedicated model
moved {
  from = module.onprem-ext[0]
  to   = module.onprem-ext-dedicated[0]
}
#

# Uncomment if migrating from pre 2.x shared model
#moved {
#  from = module.onprem-ext[0]
#  to   = module.onprem-ext-shared[0]
#}
#End

# Below this point, these are cross module moves, not supported on older versions of TF

## Moves of FW API objects to separate module
#
#moved {
#  from = module.standalone[0].module.vpc[0].restapi_object.fw_config[0]
#  to   = module.palo_alto[0].restapi_object.fw_config
#}
#
#moved {
#  from = module.standalone[0].module.vpc[1].restapi_object.fw_config[0]
#  to   = module.palo_alto[1].restapi_object.fw_config
#}
#
#moved {
#  from = module.standalone[0].module.vpc[2].restapi_object.fw_config[0]
#  to   = module.palo_alto[2].restapi_object.fw_config
#}
#
#moved {
#  from = module.standalone[0].module.vpc[3].restapi_object.fw_config[0]
#  to   = module.palo_alto[3].restapi_object.fw_config
#}
#
#moved {
#  from = module.standalone[0].module.vpc[4].restapi_object.fw_config[0]
#  to   = module.palo_alto[4].restapi_object.fw_config
#}
#
#moved {
#  from = module.standalone[0].module.vpc[5].restapi_object.fw_config[0]
#  to   = module.palo_alto[5].restapi_object.fw_config
#}
#
#moved {
#  from = module.standalone[0].module.vpc[6].restapi_object.fw_config[0]
#  to   = module.palo_alto[6].restapi_object.fw_config
#}
#
#moved {
#  from = module.standalone[0].module.vpc[7].restapi_object.fw_config[0]
#  to   = module.palo_alto[7].restapi_object.fw_config
#}
#
## Move of IAM role to global resources
#
#moved {
#  from = module.standalone[0].aws_iam_role.vpc_flow_logs
#  to   = module.global[0].aws_iam_role.vpc_flow_logs
#}
