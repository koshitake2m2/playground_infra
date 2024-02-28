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
tfenv list-remote
tfenv install 1.5.7
tfenv list
tfenv use 1.5.7
```

## aws

```bash
# terraformを実行する
cd terraform/XXXX # main.tfがあるところへ
terraform init
terraform plan
terraform apply --auto-approve
terraform destroy --auto-approve

ssh-keygen -t rsa -b 4096 -m PEM -f ./ssh_keys/ssh_key
PUBLIC_IP=xxx
ssh -i ./ssh_keys/ssh_key ubuntu@${PUBLIC_IP}
ssh-keygen -R ${PUBLIC_IP}
```

### ec2

```bash
# 管理者権限でないと80ポートを使えない
sudo su -
curl https://get.volta.sh | bash
exec $SHELL -l
volta install node
npm i -g http-server
http-server -p 80
```

## firebase

```bash
# 認証
gcloud auth login

# カレントプロジェクトのactivate
gcloud config configurations activate XXXX
gcloud config configurations list

# terraform用に環境変数を読み込む
cd terraform/XXXX
source .env


```
