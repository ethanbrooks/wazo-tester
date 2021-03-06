FROM python:3.7-slim-buster
WORKDIR /usr/src
COPY . /usr/src/
RUN true && \
    apt-get update -qq && apt-get install -y --no-install-recommends bash build-essential libpq-dev && \
    rm -rf /var/lib/apt/lists/* && \
    make setup dist && \
    find dist

FROM python:3.7-slim-buster
LABEL maintainer="Wazo Authors <dev@wazo.community>"
ENV VERSION 1.1.0
RUN true && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        bash \
        iproute2 \
        sip-tester \
        net-tools \
        iputils-ping \
        nano \
        vim \
        jq \
        redis-tools \
        watch \
        screen \
        netcat \
        sngrep \
        curl \
        build-essential \
        netcat \
        libpq-dev && \
    rm -rf /var/lib/apt/lists/*
RUN pip3 install pytest
COPY --from=0 /usr/src/dist /dist
RUN pip3 install /dist/wazotester-*-py3-none-any.whl && rm -r /dist
COPY ./scripts/wait-for /usr/bin/wait-for
RUN chmod +x /usr/bin/wait-for
RUN curl -SLOk https://releases.hashicorp.com/consul-template/0.23.0/consul-template_0.23.0_linux_amd64.tgz \
    && tar -xvf consul-template_0.23.0_linux_amd64.tgz \
    && chmod a+x consul-template \
    && mv consul-template /usr/sbin/ \
    && rm -rf consul-template*
