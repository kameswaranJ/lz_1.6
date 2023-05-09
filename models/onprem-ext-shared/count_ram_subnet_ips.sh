#!/bin/bash

set -e

if [ -n "$2" ]
then
  CREDENTIALS=()
  IFS=$'\t' read -r -a CREDENTIALS <<< "$(aws sts assume-role \
    --region "$1" \
    --role-arn "$2" \
    --role-session-name "stla-lz-terraform" \
    --query "[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]" \
    --output text)"

  export AWS_ACCESS_KEY_ID="${CREDENTIALS[0]}"
  export AWS_SECRET_ACCESS_KEY="${CREDENTIALS[1]}"
  export AWS_SESSION_TOKEN="${CREDENTIALS[2]}"
fi

IFS=';' read -ra SUBNET_ARNS <<< "$(aws ram list-resources --resource-owner SELF --resource-type ec2:Subnet --resource-share-arns "$3" --query "resources[].arn | join(';', @)" | tr -d '"')"
SUBNET_IDS=()
for SUBNET_ARN in "${SUBNET_ARNS[@]}"
do
  SUBNET_ID=$(echo "${SUBNET_ARN}" | awk -F'/' '{print (NF>1)? $NF : ""}')
  SUBNET_IDS+=("$SUBNET_ID")
done
RESULT=$(aws ec2 describe-subnets --subnet-ids "${SUBNET_IDS[@]}" --query 'Subnets[].AvailableIpAddressCount | sum(@)')
echo "{\"count\" : \"$RESULT\"}"
