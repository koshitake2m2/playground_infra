# fake-gcs-server

```bash
# Get meta data
curl http://0.0.0.0:4443/storage/v1/b
curl http://0.0.0.0:4443/storage/v1/index.html
curl http://0.0.0.0:4443/storage/v1/b/my-bucket/o
curl http://0.0.0.0:4443/storage/v1/b/my-bucket/o/index.html

# Get object
curl http://localhost:4443/my-bucket/index.html
curl "http://0.0.0.0:4443/download/storage/v1/b/my-bucket/o/index.html?alt=media"
```
