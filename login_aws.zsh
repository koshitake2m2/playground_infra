#!/bin/zsh
# サブシェルではなくカレントシェルで実行してください.
# e.g. source ~/koshitake2m2/playground_infra/login_aws.zsh

# 0. ブラウザの方で該当のロールでIAM Identity Center(SSO)にログインしておく. 

# 0. 環境変数の適用
echo "$(dirname $0)/.env"
echo
cat "$(dirname $0)/.env"
echo
source "$(dirname $0)/.env"

# 1. IAM Identity Center(SSO)で認証する. defaultでは8hでセッションが切れる.
# aws configure sso < <(echo $session_name; echo $start_url; echo ap-northeast-1; echo; echo; echo;)
aws configure sso --profile $profile --region ap-northeast-1 --output json

# SSO session name : XXXX # 任意の名前
# SSO start URL [None]: https://XXXX.awsapps.com/start # IAM Identity CenterのSettings summaryに記載してある
# SSO region [None]: ap-northeast-1
# SSO registration scopes [sso:account:access]:
# ...
# CLI default client Region [ap-northeast-1]:
# CLI default output format: json

aws sts get-caller-identity --profile $profile --no-cli-pager
# {
#     "UserId": "XXXX",
#     "Account": "XXXX",
#     "Arn": "XXXX"
# }

# 2. STS short-term credentialsを取得する. 更新日が最新のもの2つ
for t in `ls -t ~/.aws/sso/cache/*.json | head -n 2 | xargs cat | jq -r ".accessToken"`; do
  if test $t != "null"; then
    access_token=$t; 
  fi;
done;

# 2つのjsonのうちaccessTokenがある方のaccessTokenを利用する
tmp_file=$(mktemp)
aws sso get-role-credentials \
  --account-id $account_id \
  --role-name $role_name \
  --access-token $access_token \
  --region ap-northeast-1 \
  --no-cli-pager >> $tmp_file;

# {
#     "roleCredentials": {
#         "accessKeyId": "XXXX",
#         "secretAccessKey": "XXXX",
#         "sessionToken": "XXXX"
#         "expiration": XXXX
#     }
# }

# 3. terraform用に環境変数にcredentialsを設定する
export AWS_ACCESS_KEY_ID=$(cat $tmp_file | jq -r ".roleCredentials.accessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat $tmp_file | jq -r ".roleCredentials.secretAccessKey")
export AWS_SESSION_TOKEN=$(cat $tmp_file | jq -r ".roleCredentials.sessionToken")   
rm -f $tmp_file 

rm -f ~/.aws/credentials
cat <<-EOF > ~/.aws/credentials
[${account_id}_${role_name}]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
aws_session_token=$AWS_SESSION_TOKEN
EOF

echo "[info] login aws done"
