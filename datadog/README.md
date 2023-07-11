
## docker agent

https://docs.datadoghq.com/containers/docker/?tab=standard

docker run -d --name dd-agent -v /var/run/docker.sock:/var/run/docker.sock:ro -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -e DD_API_KEY=$DD_API_KEY -e DD_SITE="ap1.datadoghq.com" gcr.io/datadoghq/agent:7