## ec2-rds

- public subnet に ec2
- pravate subnet に rds

```bash
# in ec2
sudo apt-get update
sudo apt install postgresql
psql --version

DB_NAME=mydb
DB_USERNAME=username
# DB識別子. GUI上から確認できる
DB_HOSTNAME=terraform-xxxxxxxxxxxxxxxxxxxxxxx.yyyyyyyyyy.ap-northeast-1.rds.amazonaws.com
psql -d $DB_NAME -h $DB_HOSTNAME -U $DB_USERNAME
```
