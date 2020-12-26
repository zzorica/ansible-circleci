
FROM alpine:3.12
LABEL maintainer="Zoran Zorica <zzorica@soultrace.net>"
RUN set -eux \
	&& apk add --no-cache python3 py3-pip bash git jq openssh curl ansible ca-certificates tar gzip
WORKDIR /opt
ENTRYPOINT []
CMD    ["/bin/bash"]
