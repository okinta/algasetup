FROM alpine:3.11

RUN apk add --no-cache \
        bash \
        curl \
        openssh-client \
        tini \
        unzip

# Install vultr-cli so we can provision machines
RUN set -x \
    && wget -q -O vultr-cli.tar.gz https://s3.okinta.ge/vultr-cli_0.3.0_linux_64-bit.tar.gz \
    && tar -xzf vultr-cli.tar.gz -C /usr/local/bin \
    && chmod o+x /usr/local/bin/vultr-cli \
    && rm -f vultr-cli.tar.gz

# Grab wait-for-it script so we know when gateway is ready
RUN wget -q -O wait-for-it.zip \
        https://s3.okinta.ge/wait-for-it-c096cface5fbd9f2d6b037391dfecae6fde1362e.zip \
    && unzip -q wait-for-it.zip \
    && rm -f wait-for-it.zip \
    && mv wait-for-it-master/wait-for-it.sh /usr/local/bin/wait-for-it \
    && chmod o+x /usr/local/bin/wait-for-it

# Grab server script for provisioning machines
ARG ALGA_VERSION=add8e8d42f441e897474a98933d8c6716222446e
RUN wget -q -O alga-infra.zip \
        https://github.com/okinta/alga-infra/archive/$ALGA_VERSION.zip \
    && unzip -q alga-infra.zip \
    && mv alga-infra-$ALGA_VERSION /opt/alga-infra \
    && chmod o+x /opt/alga-infra/server \
    && ln -s /opt/alga-infra/server /usr/local/bin/server \
    && rm -f alga-infra.zip

RUN adduser -D regan
COPY entrypoint.sh /entrypoint.sh
COPY setup.sh /setup.sh
RUN chmod o+x /entrypoint.sh
RUN chmod o+x /setup.sh
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
CMD ["setup"]
