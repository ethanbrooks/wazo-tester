FROM python:3.8.0-alpine3.10
WORKDIR /
COPY . /
RUN apk update \
    && apk add --virtual build-dependencies \
        build-base \
        gcc \
        make \
        git \
    && apk add \
        bash \
        python3 \
        py-pip \
        make
RUN make setup
RUN make dist


FROM python:3.8.0-alpine3.10
LABEL maintainer="Wazo Authors <dev@wazo.community>"
ENV VERSION 1.1.0
RUN apk add --update \
    bash \
    sudo \
    netcat-openbsd \
    iproute2 \
    sngrep \
    ngrep \
    sipsak \
    sipp \
    curl \
    jq \
    python3 \
    py-pip
RUN pip3 install pytest
COPY --from=0 /dist/wazotester-1.1.tar.gz /wazotester-1.1.tar.gz
RUN pip3 install /wazotester-1.1.tar.gz && rm /wazotester-1.1.tar.gz
COPY ./scripts/wait-for /usr/bin/wait-for
RUN chmod +x /usr/bin/wait-for
