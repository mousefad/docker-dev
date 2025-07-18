FROM debian:latest

ARG REGULAR_USER
ARG TZ
ARG DOMAIN
ARG HOSTNAME

ENV DEBIAN_FRONTEND=noninteractive

# Install general packages
RUN apt-get update
RUN apt-get -o Acquire::Retries=5 install -y openssh-server vim postfix tzdata figlet mailutils sudo iputils-ping dnsutils

# Configure sshd
RUN mkdir -p /var/run/sshd
RUN sed -i '/^PermitRootLogin /d' /etc/ssh/sshd_config
RUN echo "PermitRootLogin prohibit-password" >> /etc/ssh/sshd_config

# Configure REGULAR_USER to allow public-key auth
RUN useradd -m $REGULAR_USER -s /bin/bash
COPY ./ssh/ /home/$REGULAR_USER/.ssh/
RUN chmod 700 /home/$REGULAR_USER/.ssh
RUN chmod 600 /home/$REGULAR_USER/.ssh/authorized_keys
RUN chown -R $REGULAR_USER:users /home/$REGULAR_USER

# Set machie timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Banner on login showing machine FQDN
RUN echo $HOSTNAME.$DOMAIN | sed 's/\./ . /g' | figlet > /etc/motd

# Expose necessary ports
EXPOSE 22

# Host specific setup...
RUN apt-get -o Acquire::Retries=5 install -y fossil git

# Config postfix to relay to mail host
RUN postconf "maillog_file = /dev/stdout"
RUN postconf "mydestination = localhost.localdomain, localhost"
RUN postconf "relay_domains = dev.local"
RUN postconf "transport_maps = hash:/etc/postfix/transport"
RUN postconf "maillog_file = /dev/stdout"
RUN echo 'dev.local smtp:[mail.dev.local]' > /etc/postfix/transport
RUN postmap /etc/postfix/transport
RUN cp /etc/resolv.conf /var/spool/postfix/etc/resolv.conf

# Clean up a bit
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Run postfix in the background and then sshd logs to container output
#CMD service postfix start && service ssh start && sudo $REGULAR_USER fossil server /var/fossil
CMD service ssh start && /usr/sbin/postfix start-fg

