# containers

Container images built on upstream images, for [Diaoul/home-ops](https://github.com/Diaoul/home-ops).

Each `apps/<app>/` holds a `Dockerfile` whose `FROM` line pins the upstream tag and digest, and an
optional executable `test.sh` that receives the built image. Renovate bumps the `FROM` line and
merges once the build and test pass; the merge publishes `ghcr.io/diaoul/<app>:<upstream tag>`.

| App | Change from upstream |
|---|---|
| `hermes-agent` | The sealed venv also carries the `firecrawl` extra, for a self-hosted Firecrawl. |
