FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y curl nano && \
    curl -L https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh -o bootstrap_salt.sh && \
    chmod +x /bootstrap_salt.sh && \
    /bootstrap_salt.sh -X -d

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
