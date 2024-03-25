## ec2-elb

- public subnet に ec2 が 2 つ
- nlb が IP アドレスを持つ
- nlb が alb へ
- alb が ec2 へ
- alb, nlb の DNS 名にブラウザでアクセスすれば ec2 にアクセスできる
  - alb の DNS 名: http://alb-XXXXXXXXXX.ap-northeast-1.elb.amazonaws.com/
  - nlb の DNS 名: http://nlb-XXXXXXXXXXXXXXXX.elb.ap-northeast-1.amazonaws.com/
  - 何度かアクセスしていれば `1a` `1c` のどちらかが表示されることが確認できる
- nlb や alb の DNS 名を route53 とか外部の DNS で設定しても、いい感じにロードバランスできる

```bash
# user_dataの結果がわかる
sudo cat /var/log/cloud-init-output.log
```

### 注意点

- terraform destroy で aws_internet_gateway.main は 16 分くらいかかる場合がある
- うまく destroy できない場合は手動で削除する
