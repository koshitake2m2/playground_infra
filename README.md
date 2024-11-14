# playground_infra

## localstack

### install

```bash
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
