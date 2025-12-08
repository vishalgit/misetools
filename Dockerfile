FROM ubuntu:noble

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
fd-find \
python3-pip \
python3-pynvim \
python3-venv \
luarocks \
ripgrep

RUN add-apt-repository universe -y \
&& apt-get update && apt-get upgrade -y \
&& apt-get install -y --no-install-recommends \
wl-clipboard \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

#Copy Certs
COPY milliman.crt /usr/local/share/ca-certificates/milliman.crt
RUN chmod 644 /usr/local/share/ca-certificates/milliman.crt && \
update-ca-certificates && mkdir -p /root/certs
COPY milliman.pem /root/certs/milliman.pem

# Setup non root user
ARG user=ubuntu
ARG group=ubuntu
ARG uid=1000
ARG gid=1000
ARG email=vishal.reply@gmail.com
ARG name="Vishal Saxena"
ARG homedir=/home/${user}

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
RUN cd && mkdir -p ${homedir}/.certs
COPY --chown=${user}:${group} milliman.crt ${homedir}/.certs/milliman.crt
COPY --chown=${user}:${group} milliman.pem ${homedir}/.certs/milliman.pem

# Copy config files
RUN mkdir -p ${homedir}/.config/rclone
COPY --chown=${user}:${group} rclone.conf ${homedir}/.config/rclone/rclone.conf

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


ENV TERM=xterm-256color
ENV COLORTERM=truecolor
ENV EDITOR=nvim
ENV VISUAL=nvim
ENV NODE_EXTRA_CA_CERTS=${homedir}/.certs/milliman.pem
RUN echo "gem: --no-document" >> ${homedir}/.gemrc
# Setup mise
RUN curl https://mise.run | sh
ENV PATH="${homedir}/.local/bin:$PATH"
RUN echo "eval \"\$(mise activate zsh)\"" >> ${homedir}/.config/ezsh/ezshrc.zsh
RUN mkdir -p ${homedir}/.config/mise
COPY --chown=${user}:${group} mise.toml ${homedir}/.config/mise/config.toml 

RUN mise install

# Setup AstroNvim
RUN rm -rf /home/${user}/.config/astro \
&& git clone https://github.com/vishalgit/astrotemplate /home/${user}/.config/astro \
&& echo 'alias avim="NVIM_APPNAME=astro nvim"' >> /home/${user}/.config/ezsh/ezshrc.zsh \
&& cd /home/${user}/.config/astro \
&& git remote add upstream https://github.com/AstroNvim/template \
&& git remote set-url --push upstream DISABLE

# Enable kata
ARG kata_location=${homedir}/.local/bin
RUN git clone https://github.com/vishalgit/vim-kata && mv vim-kata ${homedir}/.vim-kata && \
echo "#!/bin/bash" > ${kata_location}/kata && \
echo "export NVIM_APPNAME=astro" >> ${kata_location}/kata && \
echo "cd ${homedir}/.vim-kata" >> ${kata_location}/kata && \
echo "./run.sh" >> ${kata_location}/kata && \
chmod u+x ${kata_location}/kata
 