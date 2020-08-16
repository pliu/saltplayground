FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y curl && \
    curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh && \
    chmod +x /bootstrap_salt.sh && \
    /bootstrap_salt.sh

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
