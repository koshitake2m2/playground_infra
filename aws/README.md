# Description

## Tips

```bash
# Login AWS.
zsh ../login_aws.zsh

# Removes junk files.
./clean.sh
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
