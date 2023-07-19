#!/bin/sh
aws sqs create-queue --queue-name play-sample-queue --endpoint-url http://localhost:4567

# see: https://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html#description
# you must use `us-east-1` region.
aws s3api create-bucket --bucket play-sample-bucket --region us-east-1 --endpoint-url http://localhost:4567