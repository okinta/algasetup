FROM okinta/agrix

COPY --from=0 /usr/local/bin/wait-for-it /usr/local/bin/wait-for-it

RUN apk add --no-cache \
        bash \
        tini

COPY files /
WORKDIR /usr/local/bin
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
