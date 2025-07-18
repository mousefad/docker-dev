FROM dev-base:latest
ARG REGULAR_USER
ARG DOMAIN
ARG HOSTNAME

# Host specific setup...
RUN apt-get -o Acquire::Retries=5 install -y fossil git

# Config postfix to relay to mail host
RUN postconf "append_dot_mydomain = yes"
RUN postconf "maillog_file = /dev/stdout"
RUN postconf "mydestination = localhost.localdomain, localhost"
RUN postconf "relay_domains = dev.local"
RUN postconf "transport_maps = hash:/etc/postfix/transport"
RUN postconf "maillog_file = /dev/stdout"
RUN echo 'dev.local smtp:[mail.dev.local]' > /etc/postfix/transport
RUN postmap /etc/postfix/transport
RUN cp /etc/resolv.conf /var/spool/postfix/etc/resolv.conf

# Banner on login showing machine FQDN
RUN echo $HOSTNAME.$DOMAIN | sed 's/\./ . /g' | figlet > /etc/motd

# Clean up a bit
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Run postfix in the background and then sshd logs to container output
#CMD service postfix start && service ssh start && sudo $REGULAR_USER fossil server /var/fossil
CMD service ssh start && /usr/sbin/postfix start-fg

