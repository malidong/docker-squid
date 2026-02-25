# docker-squid
Lightweight Docker image to run Squid (HTTP/HTTPS proxy) on Alpine Linux.

Quick start

Build locally:

```bash
./docker_build.sh
```

Run with Docker:

```bash
docker run -d --name docker-squid -p 3128:3128 \
  -v $(pwd)/etc-squid:/etc/squid \
  -v $(pwd)/squid-cache:/var/cache/squid \
  -v $(pwd)/squid-logs:/var/log/squid \
  malidong/docker-squid:latest
```

Run with docker-compose:

```bash
docker-compose up -d
```

Notes and recommendations

- The image uses `alpine:latest` as base and includes `tini` to handle reaping and signals.
- Do NOT expose the proxy port to the public internet without proper access controls (firewall, VPN, or authentication).
- To customize behavior, edit the files under `etc-squid/` (they are mounted into the container). The container watches `/etc/squid` and will `reconfigure` Squid when configs change.

Suggested mounts

- `/etc/squid` — configuration (you should keep a backup outside the container)
- `/var/cache/squid` — cache directory (improves performance)
- `/var/log/squid` — logs (rotate or collect centrally)

If you want, I can also:

- Add an example `docker-compose.override.yml` with authentication enabled
- Add GitHub Actions to build and publish images (already added: .github/workflows/docker-publish.yml)

CI notes

- The repository includes a GitHub Actions workflow at `.github/workflows/docker-publish.yml` which builds and pushes the image to GitHub Container Registry (GHCR) on pushes to `main` and tags. To enable pushing to Docker Hub, set the repository secrets `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, and (optionally) `DOCKERHUB_REPO`.
