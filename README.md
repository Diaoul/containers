# containers

Container images built on upstream images, for [Diaoul/home-ops](https://github.com/Diaoul/home-ops).

The pipeline follows [home-operations/containers](https://github.com/home-operations/containers):
each `apps/<app>/` has a `docker-bake.hcl` whose Renovate-annotated `VERSION` picks the upstream
release, a `Dockerfile`, and a `test.sh` that receives the built image. Renovate bumps `VERSION`
and merges once the pull request's `Build Success` check passes; the merge publishes
`ghcr.io/diaoul/<app>`. A failed release opens an issue.

Left out from upstream: new-app announcements, deprecation, stale, CodeQL, vulnerability scans,
the labeler and the Go tests. Images are built for `linux/amd64` only.

| App | Change from upstream |
|---|---|
| `hermes-agent` | The sealed venv also carries the `firecrawl` extra, for a self-hosted Firecrawl. |
