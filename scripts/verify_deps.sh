#!/bin/bash
# © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#

echo "CodeScanning: Deps: AWS CLI installed $(command -v aws)"
echo "CodeScanning: Deps: Terraform installed $(command -v terraform)"
echo "CodeScanning: Deps: Checkov installed $(command -v checkov)"
echo "CodeScanning: Deps: TFSec installed $(command -v tfsec)"
echo "CodeScanning: Deps: TFLint installed $(command -v tflint)"
echo "CodeScanning: Deps: Bandit installed $(command -v bandit)"
echo "CodeScanning: Deps: PyTest installed $(command -v pytest)"
echo "CodeScanning: Deps: PyLint installed $(command -v pylint)"
echo "CodeScanning: Deps: ShellCheck installed $(command -v shellcheck)"

echo "====== CodeScanning: Deps: Environment Variables ======="
echo "CODEBUILD_SOURCE_REPO_URL -> ${CODEBUILD_SOURCE_REPO_URL}"
echo "-------------------------------------------"
echo "CODEBUILD_BUILD_ARN -> ${CODEBUILD_BUILD_ARN}"
echo "-------------------------------------------"
echo "LZ_BASEINFRA_ENV -> ${LZ_BASEINFRA_ENV}"
echo "-------------------------------------------"
echo "GITHUB_ACTOR -> ${GITHUB_ACTOR}"
echo "-------------------------------------------"
echo "GITHUB_BASE_REF -> ${GITHUB_BASE_REF}"
echo "-------------------------------------------"
echo "GITHUB_HEAD_REF -> ${GITHUB_HEAD_REF}"
echo "-------------------------------------------"
echo "GITHUB_REF_NAME -> ${GITHUB_REF_NAME}"
echo "-------------------------------------------"
echo "GITHUB_REF -> ${GITHUB_REF}"
echo "-------------------------------------------"
echo "GITHUB_REPOSITORY -> ${GITHUB_REPOSITORY}"
echo "-------------------------------------------"
echo "GITHUB_WORKFLOW -> ${GITHUB_WORKFLOW}"
echo "-------------------------------------------"