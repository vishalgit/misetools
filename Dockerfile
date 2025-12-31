FROM ubuntu:noble

USER root
WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

#Install base system
RUN apt-get update && apt-get upgrade -y && \
apt-get install -y --no-install-recommends \
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
locate \
zip \
unzip \
gzip \
bzip2 \
xz-utils \
ripgrep \
tmux \
luarocks \
openssh-server \
chromium-browser \
xrdp \
xorg \
xorgxrdp \
i3-wm \
i3status \
dmenu \
dbus-x11 \
tini \
kitty \
fonts-symbola \
fonts-noto \
fonts-noto-color-emoji \
libatk1.0-0 \
libatk-bridge2.0-0 \
libcups2 \
libdrm2 \
libxkbcommon0 \
libgbm1 \
libgtk-3-0 \
libnss3-tools && \
apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub \
| gpg --dearmor > /usr/share/keyrings/google-chrome.gpg && \
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] \
https://dl.google.com/linux/chrome/deb/ stable main" \
> /etc/apt/sources.list.d/google-chrome.list


RUN apt-get update && apt-get install -y \
google-chrome-stable \
&& rm -rf /var/lib/apt/lists/*

#Copy Certs
COPY cert.crt /usr/local/share/ca-certificates/cert.crt
RUN chmod 644 /usr/local/share/ca-certificates/cert.crt && \
update-ca-certificates && mkdir -p /root/certs
COPY cert.pem /root/certs/cert.pem

# Setup non root user
ARG user=ubuntu
ARG group=ubuntu
ARG uid=1000
ARG gid=1000
ARG email=vishal.reply@gmail.com
ARG name="Vishal Saxena"
ARG homedir=/home/${user}

RUN echo '%'${group}' ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd_${group} \
&& chmod 0440 /etc/sudoers.d/nopasswd_${group} &&\
echo "ubuntu:ubuntu" | chpasswd

USER ${user}
WORKDIR ${homedir}

# Setup git
RUN git config --global core.editor nvim \
&& git config --global init.defaultBranch main \
&& git config --global pull.rebase true \
&& git config --global user.email ${email} \
&& git config --global user.name ${name} \
&& git config --global credential.helper ${homedir}/.secrets/gh-cred-helper.sh

RUN mkdir -p ${homedir}/.secrets
COPY --chown=${user}:${group} gh.gpg ${homedir}/.secrets/gh.gpg
COPY --chown=${user}:${group} --chmod=755 gh-cred-helper.sh ${homedir}/.secrets/gh-cred-helper.sh

# Copy certs
RUN cd && mkdir -p ${homedir}/.certs
COPY --chown=${user}:${group} cert.crt ${homedir}/.certs/cert.crt
COPY --chown=${user}:${group} cert.pem ${homedir}/.certs/cert.pem

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


ENV TERM=kitty
ENV TERMINAL=kitty
ENV COLORTERM=truecolor
ENV EDITOR=nvim
ENV VISUAL=nvim
ENV NODE_EXTRA_CA_CERTS=${homedir}/.certs/cert.pem
ENV TZ=Asia/Kolkata
RUN echo "gem: --no-document" >> ${homedir}/.gemrc
# Setup mise
RUN curl https://mise.run | sh
ENV PATH="${homedir}/.local/bin:$PATH"
RUN echo "eval \"\$(mise activate zsh)\"" >> ${homedir}/.config/ezsh/ezshrc.zsh
RUN mkdir -p ${homedir}/.config/mise

RUN mise use -g go
RUN mise use -g dotnet
RUN mise use -g ruby
RUN mise use -g gem:neovim
RUN mise use -g gem:rails
RUN mise use -g node@lts
RUN mise use -g npm:npm
RUN mise use -g npm:@anthropic-ai/claude-code
RUN mise use -g npm:typescript
RUN mise use -g npm:tree-sitter-cli
RUN mise use -g npm:neovim
RUN mise use -g npm:pnpm
RUN mise use -g rust
RUN ${homedir}/.cargo/bin/rustup component add rust-analyzer
RUN ${homedir}/.cargo/bin/rustup target add wasm32-unknown-unknown 
RUN mise use -g cargo-binstall
RUN mise settings set cargo.binstall true
RUN mise use -g cargo:cargo-leptos
RUN mise use -g cargo:leptosfmt
RUN mise use -g cargo:cargo-check
RUN mise use -g aqua:zellij-org/zellij
RUN mise use -g vfox:mise-plugins/vfox-php
RUN mise use -g neovim
RUN mise use -g aqua:jesseduffield/lazygit
RUN mise use -g aqua:junegunn/fzf
RUN mise use -g aqua:jqlang/jq
RUN mise use -g aqua:sharkdp/bat
RUN mise use -g aqua:eth-p/bat-extras
RUN mise use -g aqua:sxyazi/yazi
RUN mise use -g bun
RUN mise use -g aqua:rclone/rclone
RUN mise use -g aqua:lsd-rs/lsd


# Setup Astronvim
RUN rm -rf /home/${user}/.config/astro \
&& git clone https://github.com/vishalgit/astrotemplate /home/${user}/.config/astro \
&& echo 'alias avim="NVIM_APPNAME=astro nvim"' >> /home/${user}/.config/ezsh/ezshrc.zsh \
&& cd /home/${user}/.config/astro \
&& git remote add upstream https://github.com/AstroNvim/template \
&& git remote set-url --push upstream DISABLE
# Setup Kickstart
RUN rm -rf /home/${user}/.config/kickstart \
&& git clone https://github.com/vishalgit/kickstart.nvim /home/${user}/.config/kickstart \
&& echo 'alias kvim="NVIM_APPNAME=kickstart nvim"' >> /home/${user}/.config/ezsh/ezshrc.zsh \
&& echo 'alias nsync="rclone bisync '${homedir}'/notes mega:notes --resync --size-only"' >> /home/${user}/.config/ezsh/ezshrc.zsh \
&& cd /home/${user}/.config/kickstart \
&& git remote add upstream https://github.com/nvim-lua/kickstart.nvim \
&& git remote set-url --push upstream DISABLE

# Enable kata
ARG kata_location=${homedir}/.local/bin
RUN git clone https://github.com/vishalgit/vim-kata && mv vim-kata ${homedir}/.vim-kata && \
echo "#!/bin/bash" > ${kata_location}/kata && \
echo "export NVIM_APPNAME=kickstart nvim" >> ${kata_location}/kata && \
echo "cd ${homedir}/.vim-kata" >> ${kata_location}/kata && \
echo "./run.sh" >> ${kata_location}/kata && \
chmod u+x ${kata_location}/kata

# Setup tmux 
RUN git clone https://github.com/tmux-plugins/tpm ${homedir}/.tmux/plugins/tpm
RUN mkdir -p ${homedir}/notes
COPY --chown=${user}:${group} tmux.conf ${homedir}/.tmux.conf

# Set up nerdfont
RUN mkdir -p ${homedir}/.local/share/fonts && \
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip && \
unzip /tmp/JetBrainsMono.zip -d ${homedir}/.local/share/fonts && \
rm /tmp/JetBrainsMono.zip && \
fc-cache -fv

RUN mkdir -p ${homedir}/.config/i3
COPY --chown=${user}:${group} i3.config ${homedir}/.config/i3/config
RUN mkdir -p ${homedir}/.config/i3status
COPY --chown=${user}:${group} i3status.config ${homedir}/.config/i3status/config
RUN mkdir -p ${homedir}/.config/kitty
COPY --chown=${user}:${group} kitty.config ${homedir}/.config/kitty/kitty.conf
RUN mkdir -p /home/${user}/.pki/nssdb && \
certutil -d sql:/home/${user}/.pki/nssdb -N --empty-password && \
certutil -d sql:/home/${user}/.pki/nssdb -A -t "C,," -n "VishalCert" -i /home/${user}/.certs/cert.crt 

# --- install minimal stack ---

USER root
WORKDIR /root

# Chromium Wrapper
RUN printf '#!/bin/sh\nexec /usr/bin/google-chrome --no-sandbox --disable-dev-shm-usage "$@"\n' \
> /usr/local/bin/gc && \
chmod +x /usr/local/bin/gc && \
update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/local/bin/gc 100 && \
update-alternatives --set x-www-browser /usr/local/bin/gc

# Setup openssh-server
RUN mkdir -p /var/run/sshd
RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
# --- XRDP runtime dirs ---
RUN mkdir -p /var/run/xrdp /var/log/xrdp && \
chmod 755 /var/run/xrdp /var/log/xrdp

# --- allow XRDP rootless ---
RUN sed -i 's/^UsePrivilegeSeparation=.*/UsePrivilegeSeparation=false/' /etc/xrdp/sesman.ini

# --- i3 session ---
# assumes user already exists and HOME is correct at runtime
RUN echo "exec i3" > /etc/skel/.xsession


# --- startup cleanup script ---
COPY start-xrdp.sh /usr/local/bin/start-xrdp.sh
RUN chmod +x /usr/local/bin/start-xrdp.sh

EXPOSE 3389
EXPOSE 22

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/start-xrdp.sh"]

