#!/bin/bash
# © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#

ERROR=0

########### Block to use Terraform Scan
(
    set -e
    # Find projects to scan
    PROJECTS=$(find . -name ".scan")
    if [ -z "${PROJECTS}" ]
    then
        echo "CodeScanning: Scanning (Terraform): No projects to scan"
    else
        for PRJ in ${PROJECTS}
        do
            SCAN_DIR=$(temp=$(realpath "${PRJ}") && dirname "$temp")
            echo "CodeScanning: Scanning ${SCAN_DIR}"
            pushd "${SCAN_DIR}"
                TFVAR_FILE=$([ -f "./${LZ_BASEINFRA_ENV}.tfvars" ] && echo "./${LZ_BASEINFRA_ENV}.tfvars" || echo "./example.tfvars")
                echo "CodeScanning: Scanning: using ${TFVAR_FILE} for scanning"
                echo "CodeScanning: Scanning: Checkov"
                checkov -d . --branch "$(git rev-parse --abbrev-ref HEAD)" --var-file="${TFVAR_FILE}"

                echo "CodeScanning: Scanning: TFSec"
                tfsec . --tfvars-file="${TFVAR_FILE}"

                echo "CodeScanning: Scanning: TFLint"
                tflint --var-file="${TFVAR_FILE}"
            popd
        done
    fi
)
ERROR=$?

if [ ${ERROR} != 0 ]
then
    echo "CodeScanning: Scanning (Terraform): Problems detected, see previous output"
    exit 1
else
    echo "CodeScanning: Scanning (Terraform): No errors detected"
fi

########### Block to use Python Scan
(
    set -e
    # Find projects to scan
    PROJECTS=$(find . -name ".pyscan")
    if [ -z "${PROJECTS}" ]
    then
        echo "CodeScanning: Scanning (Python): No projects to scan"
    else
        for PRJ in ${PROJECTS}
        do
            SCAN_DIR=$(temp=$(realpath "${PRJ}") && dirname "$temp")
            echo "CodeScanning: Scanning ${SCAN_DIR}"

            echo "CodeScanning: Scanning: Bandit"
            bandit -r "${SCAN_DIR}"
            echo "CodeScanning: Scanning: PyLint"
            PYLINTRC_FILE=$([ -f "${SCAN_DIR}/.pylintrc" ] && echo "--rcfile ${SCAN_DIR}/.pylintrc" || echo "")
            echo "CodeScanning: Scanning: using ${PYLINTRC_FILE} for scanning"
            eval pylint "${PYLINTRC_FILE}" "${SCAN_DIR}" #Using eval in order to cope with the --rcfile parameter
        done
    fi
)
ERROR=$?

if [ ${ERROR} != 0 ]
then
    echo "CodeScanning: Scanning (Python): Problems detected, see previous output"
    exit 1
else
    echo "CodeScanning: Scanning (Python): No errors detected"
fi

########### Block to use Shell Scan
(
    set -e
    # Find files to scan
    SHELLSCRIPTS=$(find . -name "*.sh")
    if [ -z "${SHELLSCRIPTS}" ]
    then
        echo "CodeScanning: Scanning (Shell): No files to scan"
    else
        for SHS in ${SHELLSCRIPTS}
        do
            echo "CodeScanning: Scanning file ${SHS}"
            shellcheck "${SHS}"
        done
    fi
)
ERROR=$?

if [ ${ERROR} != 0 ]
then
    echo "CodeScanning: Scanning (Shell): Problems detected, see previous output"
    exit 1
else
    echo "CodeScanning: Scanning (Shell): No errors detected"
fi
