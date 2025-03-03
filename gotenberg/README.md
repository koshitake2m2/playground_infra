# gotenberg

## Usage

```bash
curl --request POST "http://localhost:3500/forms/chromium/convert/html" \
  --form files=@hello_sample/index.html \
  -o output/hello.pdf
```

## Tips

```bash
# health check
curl --request GET "http://localhost:3500/health"
```

## References

- [Routes | Gotenberg](https://gotenberg.dev/docs/routes)
