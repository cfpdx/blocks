#!/bin/bash

DATETIME_ARTIFACT_BUCKET=cfpdx-string-macro-artifacts
MACRO_NAME=String-Macro

aws cloudformation package \
    --template-file string.yaml \
    --s3-bucket ${DATETIME_ARTIFACT_BUCKET} \
    --output-template-file packaged.yaml

aws cloudformation deploy \
    --stack-name ${MACRO_NAME} \
    --template-file packaged.yaml \
    --capabilities CAPABILITY_IAM \
    --region us-east-1
