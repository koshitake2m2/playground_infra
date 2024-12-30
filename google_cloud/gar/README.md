# GAR

- gar

## Test Express App in Local

```bash
cd app
docker compose up -d
curl -i http://localhost:8080
docker compose down
docker image rm app_api
```

## Push Image to GAR

```bash
# create artifact registry
terraform apply

# fix .env
vim .env

# set env
source .env

# build image
cd app
docker build -t app_api . --platform linux/amd64
cd ..

# confirm image ID
docker images

# auth, if needed
gcloud auth configure-docker ${LOCATION}-docker.pkg.dev

# push
full_image_name=${LOCATION}-docker.pkg.dev/${PROJECT_ID}/${GAR_REPOSITORY}/${GAR_IMAGE_TAG}

docker tag $DOCKER_IMAGE_ID $full_image_name
docker push $full_image_name
```

## References

- [イメージを push および pull する | Artifact Registry documentation | Google Cloud](https://cloud.google.com/artifact-registry/docs/docker/pushing-and-pulling?hl=ja#linux)
