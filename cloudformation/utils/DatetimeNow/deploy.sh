#!/bin/bash

DATETIME_ARTIFACT_BUCKET=cfpdx-dt-macro-artifacts
MACRO_NAME=$(basename $(pwd))

aws cloudformation package \
    --template-file datetimenow.yaml \
    --s3-bucket ${DATETIME_ARTIFACT_BUCKET} \
    --output-template-file packaged.yaml

aws cloudformation deploy \
    --stack-name ${MACRO_NAME}-macro-east \
    --template-file packaged.yaml \
    --capabilities CAPABILITY_IAM

