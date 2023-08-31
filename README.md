# playground_infra

## localstack

### install

```
brew install localstack
brew install awscli
pip install awscli-local
```

### command

```bash
# compose.ymlの検証
localstack config validate --file compose.yml

# log
localstack logs

# start
localstack start
```

## terraform

```bash
## 1. IAM Identity Center(SSO)で認証する. defaultでは8hでセッションが切れる.
aws configure sso
# SSO session name : XXXX # 任意の名前
# SSO start URL [None]: https://XXXX.awsapps.com/start # IAM Identity CenterのSettings summaryに記載してある
# SSO region [None]: ap-northeast-1
# SSO registration scopes [sso:account:access]:
# ...
# CLI default client Region [ap-northeast-1]:
# CLI default output format: json

aws sts get-caller-identity --profile XXXX --no-cli-pager
# {
#     "UserId": "XXXX",
#     "Account": "XXXX",
#     "Arn": "XXXX"
# }

## 2. STS short-term credentialsを取得する
cat ~/.aws/sso/cache/*.json | jq

# accessTokenがある方を利用する
aws sso get-role-credentials \
  --account-id XXXX \
  --role-name PowerUserAccess \
  --access-token "XXXX" \
  --region ap-northeast-1 \
  --no-cli-pager;

# {
#     "roleCredentials": {
#         "accessKeyId": "XXXX",
#         "secretAccessKey": "XXXX",
#         "sessionToken": "XXXX"
#         "expiration": XXXX
#     }
# }

## 3. terraform用に環境変数にcredentialsを設定する

export AWS_ACCESS_KEY_ID="XXXX"
export AWS_SECRET_ACCESS_KEY="XXXX"
export AWS_SESSION_TOKEN="XXXX"

## 4. terraformを実行する
cd terraform/XXXX # main.tfがあるところへ
terraform init
terraform plan
terraform apply --auto-approve
terraform destroy --auto-approve
```
