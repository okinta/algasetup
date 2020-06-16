FROM okinta/agrix

RUN apk add --no-cache \
        bash \
        tini

COPY files /
WORKDIR /usr/local/bin
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
