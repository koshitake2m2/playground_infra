## s3-github-actions

- htmlをs3に置く
- github actionsで自動デプロイ

### tips

```bash
S3_BUCKET_NAME=XXX

# アップロード
aws s3 sync ./www "s3://${S3_BUCKET_NAME}" --delete

# アクセス
curl https://${S3_BUCKET_NAME}.s3.ap-northeast-1.amazonaws.com/index.html
```

### 注意点
- aws s3 sync では `--delete` をつけることで, オブジェクトの削除もできる
