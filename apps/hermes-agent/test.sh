#!/usr/bin/env bash
set -euo pipefail
docker run --rm --user 10000:10000 --entrypoint /opt/hermes/.venv/bin/python --workdir /tmp "$1" -c '
import firecrawl
from pm.install import venv_is_current
from pm.lock import Facts
from pm.paths import facts_path
assert "firecrawl" in Facts(facts_path()).get("venv")["extras"]
assert venv_is_current()
'
docker run --rm --user 10000:10000 --entrypoint /opt/hermes/.venv/bin/hermes --env HOME=/tmp --workdir /tmp "$1" --version
