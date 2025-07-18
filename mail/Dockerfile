FROM dev-base:latest
ARG REGULAR_USER
ARG DOMAIN
ARG HOSTNAME
ARG SUBNET

# Host specific setup...
# Config postfix as receiver for domain
RUN postconf "mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 $SUBNET"
RUN postconf "append_dot_mydomain = yes"
RUN echo "root: $REGULAR_USER" >> /etc/aliases
RUN newaliases
RUN postconf "mydomain = $DOMAIN"
RUN postconf 'mydestination = $myhostname, $mydomain, localhost.$mydomain, localhost'
EXPOSE 25

# Mutt config for REGULAR_USER
RUN apt-get -o Acquire::Retries=5 install -y mutt
COPY ./mutt/ /home/$REGULAR_USER/.mutt/
RUN mkdir /home/$REGULAR_USER/Mail
RUN chmod 700 /home/$REGULAR_USER/Mail
RUN chown -R $REGULAR_USER:users /home/$REGULAR_USER

# Banner on login showing machine FQDN
RUN echo $HOSTNAME.$DOMAIN | sed 's/\./ . /g' | figlet > /etc/motd

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Run postfix in the background and then sshd logs to container output
CMD service ssh start && postfix start-fg
