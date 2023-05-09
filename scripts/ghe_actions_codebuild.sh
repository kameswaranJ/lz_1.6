#!/usr/bin/env bash
# © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#
# Gather GITHUB* Environment Variables
PROJECT_ENV=$(env | grep -E '^GITHUB.*' | cut -d '=' -f1)
ENV_ARR=()
export TEMPLATE="{\"name\":\"%s\",\"value\":\"%s\",\"type\":\"PLAINTEXT\"}"
for EVAR in ${PROJECT_ENV}
do
  TVAR=$(eval "echo \$${EVAR}")
  if [ -n "${TVAR}" ]
  then
    TEMP_STR=$(eval "printf \${TEMPLATE} \"${EVAR}\" \"\$${EVAR}\"")
    ENV_ARR+=("${TEMP_STR}")
  fi
done
printf -v ALL_VARS '%s,' "${ENV_ARR[@]}"
OVERRIDE_VARS="[${ALL_VARS%,}]"
CODEBUILD_PROJECT=$1

# Start AWS CodeBuild Project
BUILD_ID=$(aws codebuild start-build --project-name "${CODEBUILD_PROJECT}" --insecure-ssl-override --environment-variables-override "${OVERRIDE_VARS}" --query 'build.id' --output text)
BUILD_STATUS=$(aws codebuild batch-get-builds --ids "${BUILD_ID}" --query 'builds[].buildStatus' --output text)
while [ "${BUILD_STATUS}" == "IN_PROGRESS" ]
do
  sleep 3
  BUILD_STATUS=$(aws codebuild batch-get-builds --ids "${BUILD_ID}" --query 'builds[].buildStatus' --output text)
done

# Finished Execution and result
BUILD_STATUS=$(aws codebuild batch-get-builds --ids "${BUILD_ID}" --query 'builds[].buildStatus' --output text)
echo "CodeBuild result: ${BUILD_STATUS}"
if [ "${BUILD_STATUS}" == "SUCCEEDED" ]
then
  exit 0
else
  exit 1
fi