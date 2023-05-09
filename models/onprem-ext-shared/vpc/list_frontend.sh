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

RESULT=$(aws ram list-resources --region "$1" --resource-type ec2:Subnet --resource-owner SELF --resource-share-arn "$3")
echo "$RESULT" | jq -r '{ids: [.resources[].arn | split("/")[1]] | join(",")}'
