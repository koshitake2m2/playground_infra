## ECR

- ecr

### Test

- xxx

### Tips

#### local express app

```bash
cd app

# build for local
docker compose build

# build with platform
docker build -t app_api . --platform linux/amd64

docker compose up -d
curl -i http://localhost:8080
docker compose down
docker image rm app_api
```

### ECR


```bash
# build
cd app
docker build -t app_api . --platform linux/amd64
cd ..

# confirm image ID
docker images

# fix .env
vim .env

# set env
source .env

# docker login
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

# tag
docker tag $DOCKER_IMAGE_ID ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPOSITORY}:${ECR_IMAGE_TAG}

# push
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPOSITORY}:${ECR_IMAGE_TAG}
```


### References
- [Docker イメージを Amazon ECR プライベートリポジトリにプッシュする - Amazon ECR](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/docker-push-ecr-image.html)
- [Multi-platform images | Docker Docs](https://docs.docker.com/build/building/multi-platform/)
