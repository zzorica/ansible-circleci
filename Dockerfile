FROM alpine:3.12 AS builder
RUN set -eux \
        && apk add --no-cache \
                bc \
                gcc \
                libffi-dev \
                jq \
                make \
                musl-dev \
                openssl-dev \
                python3 \
                python3-dev \
                py3-pip
ARG ANSIBLE_VERSION="2.10.4"
RUN set -eux \
	&& if [ "${ANSIBLE_VERSION}" = "latest" ]; then \
		pip3 install --no-cache-dir --no-compile ansible; \
	else \
		pip3 install --no-cache-dir --no-compile ansible==${ANSIBLE_VERSION}; \
	fi \
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

FROM alpine:3.12 as stage
RUN set -eux \
	&& apk add --no-cache python3 py3-pip py3-virtualenv bash git jq openssh curl gzip tar bash ca-certificates \
	&& ln -sf /usr/bin/python3 /usr/bin/python \
	&& ln -sf ansible /usr/bin/ansible-config \
	&& ln -sf ansible /usr/bin/ansible-console \
	&& ln -sf ansible /usr/bin/ansible-doc \
	&& ln -sf ansible /usr/bin/ansible-galaxy \
	&& ln -sf ansible /usr/bin/ansible-inventory \
	&& ln -sf ansible /usr/bin/ansible-playbook \
	&& ln -sf ansible /usr/bin/ansible-pull \
	&& ln -sf ansible /usr/bin/ansible-test \
	&& ln -sf ansible /usr/bin/ansible-vault \
	&& find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf
COPY --from=builder /usr/lib/python3.8/site-packages/ /usr/lib/python3.8/site-packages/
COPY --from=builder /usr/bin/ansible /usr/bin/ansible
COPY --from=builder /usr/bin/ansible-connection /usr/bin/ansible-connection
RUN pip3 install --upgrade pip \
        && pip3 install boto3 \
        && ansible-galaxy collection install amazon.aws

FROM scratch
LABEL maintainer="Zoran Zorica <zzorica@soultrace.net>"

COPY --from=stage / /
WORKDIR /opt
ENTRYPOINT []
CMD    ["/bin/bash"]
