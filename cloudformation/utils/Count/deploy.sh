#!/bin/bash

MACRO_NAME=Count-Macro-v2
COUNT_ARTIFACT_BUCKET=cfpdx-count-macro-artifacts

aws cloudformation package \
    --template-file template.yaml \
    --s3-bucket ${COUNT_ARTIFACT_BUCKET} \
    --output-template-file packaged.yaml

aws cloudformation deploy \
    --stack-name ${MACRO_NAME} \
    --template-file packaged.yaml \
    --capabilities CAPABILITY_IAM
