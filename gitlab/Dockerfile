FROM gitlab/gitlab-ce

ARG REGULAR_USER
ARG DOMAIN
ARG HOSTNAME
ARG TZ

# Host specific setup...
RUN apt-get update
RUN apt-get -o Acquire::Retries=5 install -y postfix
RUN apt-get -o Acquire::Retries=5 install -y mailutils
RUN apt-get -o Acquire::Retries=5 install -y dnsutils
RUN apt-get -o Acquire::Retries=5 install -y iputils-ping
RUN apt-get -o Acquire::Retries=5 install -y vim
RUN apt-get -o Acquire::Retries=5 install -y tzdata
RUN apt-get -o Acquire::Retries=5 install -y figlet

# Set machine timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN echo "set mouse=" >> /etc/vim/vimrc

# Config postfix to relay to mail host
RUN postconf "myhostname = localhost.local"
RUN postconf "append_dot_mydomain = yes"
RUN postconf "maillog_file = /dev/stdout"
RUN postconf "mydestination = localhost.localdomain, localhost"
RUN postconf "relay_domains = dev.local"
RUN postconf "transport_maps = hash:/etc/postfix/transport"
RUN postconf "inet_interfaces = all"
RUN postconf -X myorigin
RUN postconf -X relay_transport
RUN echo 'dev.local smtp:[mail.dev.local]' > /etc/postfix/transport
RUN postmap /etc/postfix/transport

# Banner on login showing machine FQDN
RUN echo $HOSTNAME.$DOMAIN | sed 's/\./ . /g' | figlet > /etc/motd

# Clean up a bit
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Run postfix in the background and then sshd logs to container output
CMD nslookup $HOSTNAME.$DOMAIN && cp /etc/resolv.conf /var/spool/postfix/etc/resolv.conf && postfix start && /assets/init-container

