## Fargate

depends on [ecr](../ecr/README.md)

- vpc
- alb
- ecs fargate
- github actions
  - [deploy-fargate.yml](/.github/workflows/deploy-fargate.yml)


### Test

- albのDNS名に対してcurlする
  - `curl http://alb-XXXXXXXXXX.ap-northeast-1.elb.amazonaws.com/`

### Tips

```bash
```

### TODO

- pull through cache
  - nodeをdocker hubからpullするのをやめて, ECR publicにあるnodeを利用する
    - https://gallery.ecr.aws/docker/library/node
      - public.ecr.aws/docker/library/node:18.20.3-alpine3.20
  - Dockerfileにuriを指定する必要があり, credentialなIDを含ませないようにしたいのでちょっと面倒
- workflow or jobを分ける
  - pushing to ECR
  - deploying to ECS
- ECRにあるimageの自動削除


### 注意点
- ECSのタスク定義のplatformとdocker imageのplatformが一致していないとエラーになる
  - `exec /usr/local/bin/docker-entrypoint.sh: exec format error`


### References
- [TerraformでECS(Fargate)構築｜ECS(Fargate)でnextjs+laravel+rds環境構築](https://zenn.dev/nicopin/books/58c922f51ea349/viewer/77f980)
- [AWS ECS Fargate ALBを設定する #AWS - Qiita](https://qiita.com/oizumi-yuta/items/532fe4c22bfc790a134c#%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E3%82%92%E4%BD%9C%E6%88%90%E3%81%99%E3%82%8B)
- [AWS FargateにExpress.jsをデプロイする手順](https://zenn.dev/program_panda/articles/d6fc8b147d7739)
- [TerraformでECS on Fargate構築 #AWS - Qiita](https://qiita.com/s_yanada/items/e9c6c096b5df7f6c7bf1)
- [Fargateをスポットで7割引で使うFargate Spotとは？ #reinvent | DevelopersIO](https://dev.classmethod.jp/articles/fargate-spot-detail/)
- [Amazon Elastic Container Serviceへのデプロイ - GitHub Docs](https://docs.github.com/ja/actions/deployment/deploying-to-your-cloud-provider/deploying-to-amazon-elastic-container-service)
