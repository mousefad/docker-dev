FROM debian:latest

# Install dependencies
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server vim postfix mutt tmux figlet mailutils curl
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure sshd and users
RUN mkdir -p /var/run/sshd
RUN sed -i '/^PermitRootLogin /d' /etc/ssh/sshd_config
RUN echo "PermitRootLogin prohibit-password" >> /etc/ssh/sshd_config

# Users with ssh public key auth
RUN useradd -m mng -s /bin/bash
RUN mkdir -p /home/mng/.ssh /home/mng/Mail
COPY ./ssh_key.pub /home/mng/.ssh/authorized_keys
COPY ./mutt/ /home/mng/.mutt/
RUN chmod 700 /home/mng/.ssh /home/mng/Mail
RUN chmod 600 /home/mng/.ssh/authorized_keys
RUN chown -R mng:users /home/mng

# Config postfix
RUN echo 'root: mng' >> /etc/aliases
RUN newaliases
RUN postconf 'mydomain = dev.local'
RUN postconf 'mydestination = $myhostname, $mydomain, localhost, localhost.dev.local'
RUN postconf 'mydestination = $myhostname, $mydomain, localhost, localhost.dev.local'

RUN figlet mail . dev . local > /etc/motd

# expose necessary ports
EXPOSE 22
EXPOSE 25

CMD service postfix start && /usr/sbin/sshd -D
