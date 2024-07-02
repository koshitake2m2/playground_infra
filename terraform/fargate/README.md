## Fargate

depends on [ecr](../ecr/README.md)

- vpc
- [ ] alb
- [ ] ecr
  - [ ] pull through cache
- [ ] fargate
- [ ] github actions
  - push image to ecr
  - deploy fargate


### Test

- albのDNS名に対してcurlする

### Tips

```bash
```

### 注意点
- ECSのタスク定義のplatformとdocker imageのplatformが一致していないとエラーになる
  - `exec /usr/local/bin/docker-entrypoint.sh: exec format error`


### References
- [TerraformでECS(Fargate)構築｜ECS(Fargate)でnextjs+laravel+rds環境構築](https://zenn.dev/nicopin/books/58c922f51ea349/viewer/77f980)
- [AWS ECS Fargate ALBを設定する #AWS - Qiita](https://qiita.com/oizumi-yuta/items/532fe4c22bfc790a134c#%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E3%82%92%E4%BD%9C%E6%88%90%E3%81%99%E3%82%8B)
- [AWS FargateにExpress.jsをデプロイする手順](https://zenn.dev/program_panda/articles/d6fc8b147d7739)
- [TerraformでECS on Fargate構築 #AWS - Qiita](https://qiita.com/s_yanada/items/e9c6c096b5df7f6c7bf1)
- [Fargateをスポットで7割引で使うFargate Spotとは？ #reinvent | DevelopersIO](https://dev.classmethod.jp/articles/fargate-spot-detail/)
