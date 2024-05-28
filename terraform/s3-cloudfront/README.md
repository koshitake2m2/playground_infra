## s3-cloudfront

- htmlをs3に置く
- cloudfrontでs3にアクセスする

### tips

```bash
# アクセスできない
S3_BUCKET_NAME=XXX
curl https://${S3_BUCKET_NAME}.s3.ap-northeast-1.amazonaws.com/allow.html

# アクセスできる
CLOUDFRONT_DOMAIN=XXX.cloudfront.net
curl https://${CLOUDFRONT_DOMAIN}/allow.html
```

### 注意点
