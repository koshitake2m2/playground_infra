#!/bin/sh
aws sqs create-queue --queue-name play-sample-bucket --endpoint-url http://localhost:4567
