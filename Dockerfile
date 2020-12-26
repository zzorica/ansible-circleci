
FROM alpine:3.12
LABEL maintainer="Zoran Zorica <zzorica@soultrace.net>"
RUN set -eux \
	&& apk add --no-cache python3 py3-pip py3-virtualenv git ca-certificates tar gzip openssh curl bash jq ansible
WORKDIR /opt
ENTRYPOINT []
CMD    ["/bin/bash"]
