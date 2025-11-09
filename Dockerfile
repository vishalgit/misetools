FROM ubuntu:24.04

USER root
WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

#Install base system
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
git \
curl \
wget \
zsh \
build-essential \
software-properties-common \
xclip \
sudo \
tmux \
gnupg2 \
gh \
apt-transport-https \
ca-certificates \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

#Copy Certs
COPY milliman.crt /usr/local/share/ca-certificates/milliman.crt
RUN chmod 644 /usr/local/share/ca-certificates/milliman.crt && \
update-ca-certificates && mkdir -p /root/certs
COPY milliman.pem /root/certs/milliman.pem

# Setup non root user
ARG user=vishal
ARG group=vishal
ARG uid=1001
ARG gid=1001
ARG email=vishal.reply@gmail.com
ARG name="Vishal Saxena"

RUN groupadd -g ${gid} ${group} \
&& useradd -u ${uid} -g ${group} -s /bin/bash -m ${user}
RUN echo '%'${group}' ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd_${group} \
&& chmod 0440 /etc/sudoers.d/nopasswd_${group}

USER ${user}
WORKDIR /home/${user}

# Setup git
RUN git config --global core.editor nvim \
&& git config --global init.defaultBranch main \
&& git config --global pull.rebase true \
&& git config --global user.email ${email} \
&& git config --global user.name ${name}

# Copy certs
RUN mkdir certs
COPY milliman.crt certs/milliman.crt
COPY milliman.pem certs/milliman.pem


