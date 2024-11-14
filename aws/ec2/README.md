## ec2

- シンプルな web サーバ
- vpc 内に ec2 がある
- ssh で接続可能

```bash
sudo su -
curl https://get.volta.sh | bash
exec $SHELL -l
volta install node
npm i -g http-server
http-server -p 8080
```
