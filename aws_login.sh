#!/bin/sh
 
galacxy_id="${1}"
token="$2"
 
if [ -z "$galacxy_id" ] || [ "$galacxy_id" == "--help" ]; then
  echo "Usage: ./aws_login.sh <GALACXY_ID> [MFA_TOKEN]"
else
  cp ./credentials ~/.aws/credentials
  DEVICE_ID="arn:aws:iam::066139093959:mfa/$galacxy_id"
  if [ -z "$token" ]; then
    read -p "Enter the MFA token for \"$DEVICE_ID\": " token
  fi
  result=`aws sts get-session-token --serial-number $DEVICE_ID --token-code $token`
  SecretAccessKey=`echo $result | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Credentials"]["SecretAccessKey"];'`
  AccessKeyId=`echo $result | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Credentials"]["AccessKey"];'`
  SessionToken=`echo $result | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Credentials"]["SessionToken"];'`
  echo "  access_key = \"$AccessKeyId\""
  echo "  secret_key = \"$SecretAccessKey\""
  echo "  token = \"$SessionToken\""
  export AWS_ACCESS_KEY_ID=$AccessKeyId
  export AWS_SECRET_ACCESS_KEY=$SecretAccessKey
  export AWS_SESSION_TOKEN=$SessionToken
fi
