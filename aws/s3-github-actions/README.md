## s3-github-actions

- htmlをs3に置く
- github actionsで自動デプロイ
  - [deploy-s3.yml](/.github/workflows/deploy-s3.yml)

### tips

```bash
S3_BUCKET_NAME=XXX

# アップロード
aws s3 cp ./www s3://${S3_BUCKET_NAME} --recursive
aws s3 sync ./www s3://${S3_BUCKET_NAME} --delete

# アクセス
curl https://${S3_BUCKET_NAME}.s3.ap-northeast-1.amazonaws.com/index.html
```

### 注意点
- aws s3 sync では `--delete` をつけることで, オブジェクトの削除もできる
- policyのResourceのs3のarnにslashつけてはいけない
  - good: `"${var.bucket_arn}",`
  - bad: `"${var.bucket_arn}/",`
  - 発生すること: `aws s3 sync` が失敗する
