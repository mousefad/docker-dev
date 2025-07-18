FROM debian:latest

ARG REGULAR_USER
ARG TZ
ARG DOMAIN
ARG HOSTNAME

ENV DEBIAN_FRONTEND=noninteractive

# Install general packages
RUN apt-get update
RUN apt-get -o Acquire::Retries="5" install -y openssh-server vim postfix tzdata figlet mailutils sudo iputils-ping dnsutils

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
# Config postfix as receiver for domain
RUN echo "root: $REGULAR_USER" >> /etc/aliases
RUN newaliases
RUN postconf "mydomain = $DOMAIN"
RUN postconf 'mydestination = $myhostname, $mydomain, localhost.$mydomain, localhost'
EXPOSE 25

# Mutt config for REGULAR_USER
RUN apt-get -o Acquire::Retries=5 install -y curl mutt
COPY ./mutt/ /home/$REGULAR_USER/.mutt/
RUN mkdir /home/$REGULAR_USER/Mail
RUN chmod 700 /home/$REGULAR_USER/Mail
RUN chown -R $REGULAR_USER:users /home/$REGULAR_USER

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Run postfix in the background and then sshd logs to container output
CMD service postfix start && /usr/sbin/sshd -D
