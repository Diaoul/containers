# syntax=docker/dockerfile:1
ARG VERSION
FROM docker.io/nousresearch/hermes-agent:${VERSION}

# The venv is sealed (no pip) and PM boots the selection recorded with it, so an
# extra means rebuilding it the way upstream's Dockerfile does: build_env refuses
# an existing destination, and docker.build_agent binds the source into the new venv.
# The rebuild must keep every package and command upstream shipped; a step upstream
# adds later and this one does not replay fails the build here.
WORKDIR /opt/hermes
RUN set -eu; \
    inventory() { \
        find /opt/hermes/.venv/lib -mindepth 3 -maxdepth 3 -name '*.dist-info' -printf 'pkg %f\n'; \
        find /opt/hermes/.venv/bin -mindepth 1 -maxdepth 1 -printf 'bin %f\n'; \
    }; \
    inventory | sort > /tmp/upstream.inventory; \
    extras=$(/opt/hermes/.venv/bin/python -c 'from pm.lock import Facts; from pm.paths import facts_path; print(" ".join("--extra " + e for e in Facts(facts_path()).get("venv")["extras"]))'); \
    rm -rf /opt/hermes/.venv; \
    /usr/local/bin/python3 -m pm.build_env --source /opt/hermes --python /usr/local/bin/python3 \
        --cache /opt/hermes/uv-cache --out /opt/hermes/.venv --no-install-project --sealed --record-selection \
        $extras --extra firecrawl; \
    /opt/hermes/.venv/bin/python -m docker.build_agent; \
    inventory | sort | comm -23 /tmp/upstream.inventory - > /tmp/missing; \
    if [ -s /tmp/missing ]; then echo "missing after the rebuild:" >&2; cat /tmp/missing >&2; exit 1; fi; \
    rm -f /tmp/upstream.inventory /tmp/missing; \
    chmod 0644 /opt/hermes/tools/facts.json; \
    rm -f /opt/hermes/.venv/.lock /opt/hermes/pm-runtime/.lock; \
    find /opt/hermes/uv-cache ! -type l -perm -0002 -exec chmod o-w {} +
