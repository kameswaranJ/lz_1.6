## Version 2.0.3 (2023-05-03)

* [fix] Fix the conditional on the dummy VPC for on-prem extension shared model. As a side effect, it will always be deployed.

## Version 2.0.2 (2023-04-27)

* [fix] Fix `moved` statements that account for on-prem extension shared VPC refactoring. 

## Version 2.0.1 (2023-04-13)

* [fix] Use HTTPS in GitHub references to external modules.
* [fix] Add explicit error when too many subnets are allocated for the available CIDR. 

## Version 2.0.0 (2023-04-08)

* [brk] `account_type` and `vpc_type` variables have been removed in favor of a unique `network_model` variable. Possible values are: `standalone`, `onprem-ext-shared`, `onprem-ext-dedicated` and `none` (default).
* [brk] Standalone model subnet allocation is now dynamic. To retain old behavior (useful on existing accounts), set `LEGACY_SUBNET_ALLOCATION` flag.
* [brk] Automation secret values have changed: `ACCESS_KEY` becomes `AWS_ACCESS_KEY_ID`, `SECRET_KEY` becomes `AWS_SECRET_ACCESS_KEY`, `AWS_ROLE_ARN` is added.
* [brk] Reflex integration is now disabled by default. To enable it, set `ENABLE_REFLEX_INTEGRATION` flag.
* [brk] Palo Alto integration is now disabled by default. To enable it, set `ENABLE_PALO_ALTO_INTEGRATION` flag. **Activation is required for standalone VPCs in EE.**
* [brk] Global resources like DNS hosted zone or IAM user have now a randomized suffix to avoid collisions.
* [brk] Limit the assumable role for IAM user to automation role.
* [new] Support for North America region.
* [new] Support for Europe xF.
* [new] For on-prem extension shared VPCs, the new `vpc_confidentiality` variable allows to select the relevant shared VPC. Supported values are `standard` (the default), `sensitive` and `confidential`.
* [new] In dedicated on-prem extension, support for multiple routed backend subnet type, controllable with `routed_backend_netmask_length` and `routed_backend_subnet_count`.
* [new] In dedicated on-prem extension, support multiple frontend subnets, controllable with `frontend_netmask_length` and `frontend_subnet_count`.
* [new] By default, deploy an S3 gateway endpoint in standalone VPCs.
* [new] Add standard access to CloudShell and Performance Insight (`cloudshell:*` and `pi:*`).
* [chg] For on-prem extension dedicated VPCs, the backend CIDR is now a variable instead of a dynamic IPAM allocation. Default is `100.126.0.0/16`.
* [chg] Network-model dependent variables are recalculated (not recalled from SSM) when the network model is changed: `hosted_zone`, `vpc_count`, `frontend_netmask_length`, `backend_netmask_length`, `backend_subnet_count`, `routed_backend_netmask_length`, `routed_backend_subnet_count`, `dedicated_backend_cidr`, `subnet_share_pattern`, `subnet_share_alt`, `flags`. 
* [fix] A mapping from AZ-id to AZ-name is now done before determining the AZ to deploy to. This addresses the fact that same AZs can have different names in different accounts. 

## Version 1.9.2 (2023-02-06)

* [fix] Upgrade AWS provider to 4.53 which fixes IPAM allocation error

## Version 1.9.1 (2023-02-02)

* [fix] Add standard access to AWS Simple Email Service (`ses:*`) which is required to use AWS Cognito.

## Version 1.9.0 (2023-02-01)

* [new] Add standard access to AWS Cognito (except Cognito Identity) (`cognito-idp:*` and `cognito-sync:*`).

## Version 1.8.0 (2023-01-26)

* [new] Add standard access to AWS OpenSearch (`es:*` and `aoss:*`).
* [new] Add standard access to AWS EventBridge pipes and scheduler (`pipes:*` and `scheduler:*`).
* [new] Add standard access to AWS IAM Access Analyzer (`access-analyzer:*`).
* [new] Add standard access to AWS Resource Explorer (`resource-explorer-2:*`).
* [new] Add standard access to AWS Resource Groups (`resource-groups:*` and `tag:*`).

## Version 1.7.1 (2023-01-25)

* [new] Support new `vpc_confidentiality` variable that can be `standard`, `sensitive` or `confidential`. This will impact the selection of the on-prem extension shared VPC.

## Version 1.7.0 (2022-12-05)

* [new] Add standard access to AWS DataSync (`datasync:*`).
* [new] Add REFLEX CMDB integration for each account. Needs xP intranet access. Use `NO_REFLEX_INTEGRATION` flag to disable.

## Version 1.6.2 (2022-11-25)

* [fix] Fix a reference error in standalone mode between route table association and route table for the backend subnets.

## Version 1.6.1 (2022-11-23)

* [chg] Updated keys for routing tables in standalone (to allow for only one AZ) 
* [fix] Fix error when VPC flow logs IAM role is missing 

## Version 1.6.0 (2022-11-16)

* [new] Automatic Palo Alto FW attachment for standalone VPCs. Specify `NO_FW_ATTACHMENT` flag to disable.

## Version 1.5.1 (2022-11-14)

* [new] Add standard access to AWS Step Functions (`states:*`)
* [new] Add standard access to AWS Application Autoscaling (`application-autoscaling:*`)

## Version 1.5.0 (2022-11-09)

* [new] Support for dedicated on-prem extension VPCs, with variable `vpc_type` set to `dedicated`.
* [new] Delete all default VPC in all available regions.
* [chg] Multiple on-premises extension **shared** VPCs were broken and support for them has been removed. On-premises
  multiple **dedicated** VPCs are still supported (as well as standalone).
* [chg] On-prem extension subnet allocation logic was updated. Existing VPCs cannot be updated without recreation. For
  those, keep the old logic with `LEGACY_SUBNET_ALLOCATION` flag.
* [chg] Remove `stla_lz_version` tags on all resources (version is kept in SSM).
* [chg] Add AWS Step Functions service to standard access (`states:*` IAM actions).
* [chg] Move full VPC flow logs from S3 to CloudWatch only.
* [fix] Fix version check condition

## Version 1.4.1 (2022-11-03)

* [fix] In on-prem extension mode, fix issue where backend route table lookup was not using the correct index in case of
  multiple backend subnets.

## Version 1.4.0 (2022-10-19)

* [new] Multi-region support
* [new] Multiple backend subnets support with `backend_subnet_count` variable (4 max for standalone, 2 max for
  on-premises extension).
* [new] Flags can now be associated with the environment with `flags` variable. These flags can then be checked in code
  for compatibility or other purposes.
* [new] Boolean variable `deploy_global_resources` controls whether global resources (IAM, Route53, ...) are deployed or
  not.
* [new] Support availability zone exclusion list with `az_exclusion` variable. Default exclusion list contains all AZ
  where VPCLink is unavailable.
* [chg] Workspace name is now a 4 part string `<appid>_<env_name>_<account>_<region>`. Existing workspaces must be
  renamed to be upgraded.
* [chg] Secret containing project access key is replicated to all operating regions.
* [chg] Project access key and secret is no longer stored in the state.
* [chg] Restrict automation role rights from `PowerUserAccess` to STLA standard access.
* [fix] Fix condition that wrongly triggered untagged code deployment prevention.

## Version 1.3.0 (2022-09-14)

* [new] Prevent deploying untagged code and downgrades. Can be allowed with `-var 'allow_untagged=true'`
  and  `-var 'allow_downgrade=true'`, respectively.

## Version 1.2.2 (2022-09-08)

* [fix] Missing `stla_lz_version` tag on project resources.

## Version 1.2.1 (2022-09-08)

* [fix] Better error reporting and environment variable handling in shell scripts.
* [chg] Add a `stla_lz_version` tag to all resources with the current git version.

## Version 1.2.0 (2022-09-07)

* [new] Save first-run variable values into SSM to be retrieved automatically on further execution. As such variables
  can only be set on the first run.
* [new] All parameters now accept the `<default>` value which has the same effect as not specifying the variable.
* [new] Better validation of variable values.
* [chg] The `subnet_resource_share` parameter was replaced by both `subnet_resource_share` and `subnet_share_alt`
  parameters.

## Version 1.1.0 (2022-09-02)

* [new] In standalone mode, allow preproduction accounts to also access production endpoints.

## Version 1.0.0 (2022-08-12)

* [new] Initial version
