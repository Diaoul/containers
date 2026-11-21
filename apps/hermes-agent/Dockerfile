# syntax=docker/dockerfile:1
ARG VERSION
FROM docker.io/nousresearch/hermes-agent:${VERSION}

# The venv is sealed (no pip) and PM boots the selection recorded with it, so an
# extra means rebuilding it the way upstream's Dockerfile does: build_env refuses
# an existing destination, and docker.build_agent binds the source into the new venv.
WORKDIR /opt/hermes
RUN set -eu; \
    extras=$(/opt/hermes/.venv/bin/python -c 'from pm.lock import Facts; from pm.paths import facts_path; print(" ".join("--extra " + e for e in Facts(facts_path()).get("venv")["extras"]))'); \
    rm -rf /opt/hermes/.venv; \
    python3 -m pm.build_env --source /opt/hermes --python /usr/local/bin/python3 \
        --cache /opt/hermes/uv-cache --out /opt/hermes/.venv --no-install-project --sealed --record-selection \
        $extras --extra firecrawl; \
    /opt/hermes/.venv/bin/python -m docker.build_agent; \
    chmod 0644 /opt/hermes/tools/facts.json; \
    rm -f /opt/hermes/.venv/.lock /opt/hermes/pm-runtime/.lock; \
    find /opt/hermes/uv-cache ! -type l -perm -0002 -exec chmod o-w {} +
