FROM debian:latest

ARG REGULAR_USER
ARG TZ

ENV DEBIAN_FRONTEND=noninteractive

# Install general packages
RUN apt-get update
RUN apt-get -o Acquire::Retries=5 install -y openssh-server
RUN apt-get -o Acquire::Retries=5 install -y postfix
RUN apt-get -o Acquire::Retries=5 install -y mailutils
RUN apt-get -o Acquire::Retries=5 install -y sudo
RUN apt-get -o Acquire::Retries=5 install -y iputils-ping
RUN apt-get -o Acquire::Retries=5 install -y dnsutils
RUN apt-get -o Acquire::Retries=5 install -y tzdata
RUN apt-get -o Acquire::Retries=5 install -y vim
RUN apt-get -o Acquire::Retries=5 install -y figlet

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

# Set machine timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Comfort features
RUN echo "set mouse=" >> /etc/vim/vimrc
COPY ./99_comfort.sh /etc/profile.d/99_comfort.sh
RUN chmod 755 /etc/profile.d/99_comfort.sh

# Expose ssh
EXPOSE 22
