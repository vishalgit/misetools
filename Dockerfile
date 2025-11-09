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
fontconfig \
autoconf \
libssl-dev \
libyaml-dev \
zlib1g-dev \
libffi-dev \
libgmp-dev \
bison \
gettext \
libgd-dev \
libcurl4-openssl-dev \
libedit-dev \
libicu-dev \
libjpeg-dev \
libmysqlclient-dev \
libonig-dev \
libpng-dev \
libpq-dev \
libreadline-dev \
libsqlite3-dev \
libssl-dev \
libxml2-dev \
libxslt-dev \
libzip-dev \
openssl \
pkg-config \
re2c \
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
ARG homedir=/home/${user}

RUN groupadd -g ${gid} ${group} \
&& useradd -u ${uid} -g ${group} -s /bin/bash -m ${user}
RUN echo '%'${group}' ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd_${group} \
&& chmod 0440 /etc/sudoers.d/nopasswd_${group}

USER ${user}
WORKDIR ${homedir}

# Setup git
RUN git config --global core.editor nvim \
&& git config --global init.defaultBranch main \
&& git config --global pull.rebase true \
&& git config --global user.email ${email} \
&& git config --global user.name ${name}

# Copy certs
RUN cd && mkdir -p ${homedir}/certs
COPY milliman.crt ${homedir}/certs/milliman.crt
COPY milliman.pem ${homedir}/certs/milliman.pem

# Copy config files
COPY tmux.conf ${homedir}/.tmux.conf
RUN mkdir -p ${homedir}/.config/rclone
COPY rclone.conf ${homedir}/.config/rclone/rclone.conf

# Setup oh-my-zsh
RUN mkdir -p /home/${user}/.config/ezsh
RUN git clone https://github.com/vishalgit/ezsh ezsh \
&& touch .zshrc \
&& cd ezsh \
&& chmod +x install.sh \
&& ./install.sh -n \
&& cd \
&& rm -rf ezsh 
RUN sudo chsh -s /usr/bin/zsh ${user}

# Setup mise
RUN curl https://mise.run | sh
ENV PATH="${homedir}/.local/bin:$PATH"
RUN echo "eval \"\$(mise activate zsh)\"" >> ${homedir}/.config/ezsh/ezshrc.zsh
RUN mkdir -p ${homedir}/.config/mise
ENV NODE_EXTRA_CA_CERTS=${homedir}/certs/milliman.pem
RUN mise use -g go
RUN mise use -g rust
RUN mise use -g node
RUN mise use -g dotnet
RUN mise use -g ruby
RUN mise use -g gem:rails
RUN mise use -g vfox:mise-plugins/vfox-php
RUN mise use -g neovim
RUN mise use -g aqua:rclone/rclone









