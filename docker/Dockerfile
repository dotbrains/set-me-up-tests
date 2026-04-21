FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        python3 \
        sudo \
    && useradd -m -s /bin/bash smu \
    && echo "smu ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/smu \
    && chmod 0440 /etc/sudoers.d/smu \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/harness

COPY scripts /opt/harness/scripts

RUN chmod +x /opt/harness/scripts/in-container-run.sh \
    && chmod +x /opt/harness/scripts/run-scenario.sh \
    && chmod +x /opt/harness/scripts/lib/assertions.sh
USER smu
ENV HOME=/home/smu

ENTRYPOINT ["/opt/harness/scripts/in-container-run.sh"]
