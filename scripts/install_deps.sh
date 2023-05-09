#!/bin/bash
# © 2022 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#
export TFLINT_VERSION="v0.44.1" # Not a good solution but seems that Github API might reach the threshold from our IP Addresses so the following script fails
export TFSEC_VERSION="v1.28.1"

echo "CodeScanning: Install: Cleaning Image for errors"
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections >/dev/null
sudo rm /etc/apt/sources.list.d/google-chrome.list >/dev/null 2>&1
sudo apt-get -y clean >/dev/null

echo "CodeScanning: Install: Installing requirements"
pip3 install -r ./requirements-dev.txt >/dev/null

echo "CodeScanning: Install: Installing OS packages"
sudo add-apt-repository -y ppa:git-core/ppa >/dev/null
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
echo "CodeScanning: Install: Updating System packages and repositories"
sudo apt-get -y update >/dev/null
sudo apt-get -y upgrade >/dev/null
sudo apt-get -y autoremove >/dev/null
sudo apt-get -y clean >/dev/null

echo "CodeScanning: Install: Installing project packages"
sudo apt-get install -y wget zip git jq golang-go terraform awscli shellcheck >/dev/null

GITHUB_TOKEN=$(aws ssm get-parameter --name "${SSM_PARAMETER_GHC_TOKEN_NAME}" --with-decryption | jq -r '.Parameter.Value')
export GITHUB_TOKEN
if [ -z "${GITHUB_TOKEN}" ]
then
    echo "GITHUB_TOKEN is empty"
    exit 1;
else
    echo "GITHUB_TOKEN not empty"
fi

curl -s -H "Authorization: token ${GITHUB_TOKEN}" https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash >/dev/null
sudo wget -t0 -c -q --header="Authorization: token ${GITHUB_TOKEN}" https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64 -O /usr/local/bin/tfsec >/dev/null
sudo chmod 755 /usr/local/bin/tfsec >/dev/null

echo "CodeScanning: Install: Configuring scanning tools"
tflint --init >/dev/null
echo "Finish install"
