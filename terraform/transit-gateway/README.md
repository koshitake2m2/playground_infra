## Transit Gateway

- vpc: vpc_a
  - subnet: ec2
  - subnet: TGW attachment
- vpc: vpc_b
  - subnet: ec2
  - subnet: TGW attachment

### Test

- vpc Aのec2にsshして、vpc Bのec2にcurlでリクエストする
  - TGWがないとき、ec2のPrivate IPv4 addressesでcurlできない.
    - TGW attachmentを削除したほうが確認しやすい
  - TGWがあるとき、ec2のPrivate IPv4 addressesでcurlできる.
  - ec2のPublic IPv4 addressesではcurlできる


### Tips

```bash
PUBLIC_IP=  
ssh -i ./ssh_keys/ssh_key ubuntu@${PUBLIC_IP}
```

```bash
❯ terraform console
> cidrsubnet("10.10.0.0/16", 8, 1)
"10.10.1.0/24"
```

### References
- [Transit Gatewayを利用してVPC間で通信してみた | DevelopersIO](https://dev.classmethod.jp/articles/transit-gateway-vpc/)
- [AWS Transit Gatewayを構築して分かったこと・ベストプラクティスを紐解く - サーバーワークスエンジニアブログ](https://blog.serverworks.co.jp/transit-gateway-best-practice)
- [VPC への Transit Gateway アタッチメント - Amazon VPC](https://docs.aws.amazon.com/ja_jp/vpc/latest/tgw/tgw-vpc-attachments.html)
- VPC間のprivate hosted zoneのドメイン解決
  - [Amazon Route 53 と AWS Transit Gateway を使用したハイブリッド クラウドの一元的な DNS 管理 |ネットワーキングとコンテンツ配信](https://aws.amazon.com/blogs/networking-and-content-delivery/centralized-dns-management-of-hybrid-cloud-with-amazon-route-53-and-aws-transit-gateway/)
