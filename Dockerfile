FROM ubuntu:24.04
USER root
WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

COPY google-chrome.gpg /usr/share/keyrings/google-chrome.gpg
RUN printf "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] \
http://dl.google.com/linux/chrome/deb/ stable main" \
> /etc/apt/sources.list.d/google-chrome.list

#Install base system
RUN apt-get update && \
apt-get install -y --no-install-recommends \
git \
wget \
gnupg2 \
apt-transport-https \
ca-certificates \
curl \
zsh \
build-essential \
software-properties-common \
xclip \
sudo \
gh \
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
xrdp \
xorg \
xorgxrdp \
i3-wm \
i3status \
rofi \
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
libnss3-tools \
libvterm-dev \
libjansson-dev \
libtree-sitter-dev \
cmake \
aria2 \
google-chrome-stable \
emacs-gtk \
zathura \
zathura-pdf-poppler \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

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

# Chromium Wrapper
RUN printf '#!/bin/sh\nexec /usr/bin/google-chrome-stable' \
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

# --- startup cleanup script ---
COPY start-xrdp.sh /usr/local/bin/start-xrdp.sh
RUN chmod +x /usr/local/bin/start-xrdp.sh

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

ENV NODE_EXTRA_CA_CERTS=${homedir}/.certs/cert.pem
RUN echo "gem: --no-document" >> ${homedir}/.gemrc
RUN mkdir -p ${homedir}/.bundle && echo "BUNDLE_NO_DOC: \"true\"\n" > ${homedir}/.bundle/config && echo "BUNDLE_PATH: \"/home/${user}/.bundle/vendor/bundle\"" >> ${homedir}/.bundle/config
# Setup mise
RUN curl https://mise.run | sh
ENV PATH="${homedir}/.local/bin:${PATH}"
RUN echo "eval \"\$(mise activate zsh)\"" >> ${homedir}/.config/ezsh/ezshrc.zsh
RUN mkdir -p ${homedir}/.config/mise

RUN mise use -g go
RUN mise use -g dotnet
ENV PATH="${homedir}/.dotnet/tools:${PATH}"
RUN mise use -g ruby
RUN mise use -g gem:neovim
RUN mise use -g gem:rails
RUN mise use -g node@lts
RUN mise use -g npm:npm
RUN mise use -g npm:@anthropic-ai/claude-code
RUN mise use -g npm:typescript
RUN mise use -g npm:tree-sitter-cli
RUN mise use -g npm:neovim
RUN mise use -g rust
RUN ${homedir}/.cargo/bin/rustup component add rust-analyzer
RUN ${homedir}/.cargo/bin/rustup target add wasm32-unknown-unknown 
RUN mise use -g cargo-binstall
RUN mise settings set cargo.binstall true
RUN mise use -g cargo:cargo-leptos
RUN mise use -g cargo:leptosfmt
RUN mise use -g cargo:cargo-check
RUN mise use -g vfox:mise-plugins/vfox-php
RUN mise use -g neovim
RUN mise use -g aqua:jqlang/jq
RUN mise use -g aqua:sharkdp/bat
RUN mise use -g aqua:eth-p/bat-extras
RUN mise use -g aqua:sxyazi/yazi
RUN mise use -g aqua:rclone/rclone
RUN mise use -g github:neovide/neovide

# Install doom emacs
RUN git clone https://github.com/vishalgit/doom /home/${user}/.doom.d/ 
RUN sudo ln -s /usr/bin/fdfind /usr/local/bin/fd
RUN git clone --depth 1 https://github.com/doomemacs/doomemacs /home/${user}/.emacs.d
RUN /home/${user}/.emacs.d/bin/doom install --force
ENV PATH="${homedir}/.emacs.d/bin:${PATH}"
RUN doom sync
# Set up nerdfont
RUN mkdir -p ${homedir}/.fonts && \
wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz -O ${homedir}/JetBrainsMono.tar.xz && \
tar -xvf ${homedir}/JetBrainsMono.tar.xz -C ${homedir}/.fonts && \
fc-cache -fv ${homedir}/.fonts \
&& rm -rf ${homedir}/JetBrainsMono.tar.xz

# Setup Lazyvim
RUN rm -rf /home/${user}/.config/lazyvim \
&& git clone https://github.com/vishalgit/lazyvim /home/${user}/.config/lazyvim \
&& cd /home/${user}/.config/lazyvim \
&& git remote add upstream https://github.com/LazyVim/starter \
&& git remote set-url --push upstream DISABLE
# Setup Kickstart
RUN rm -rf /home/${user}/.config/kickstart \
&& git clone https://github.com/vishalgit/kickstart.nvim /home/${user}/.config/kickstart \
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

# Setup config files
RUN mkdir -p ${homedir}/.config/i3
COPY --chown=${user}:${group} i3.config ${homedir}/.config/i3/config
RUN mkdir -p ${homedir}/.config/i3status
COPY --chown=${user}:${group} i3status.config ${homedir}/.config/i3status/config
RUN mkdir -p ${homedir}/.config/kitty
COPY --chown=${user}:${group} kitty.config ${homedir}/.config/kitty/kitty.conf
RUN mkdir -p /home/${user}/.pki/nssdb && \
certutil -d sql:/home/${user}/.pki/nssdb -N --empty-password && \
certutil -d sql:/home/${user}/.pki/nssdb -A -t "C,," -n "VishalCert" -i /home/${user}/.certs/cert.crt 
COPY --chown=${user}:${group} i3_start ${homedir}/.xsession
RUN chmod +x ${homedir}/.xsession
RUN mkdir -p ${homedir}/.config/neovide
COPY --chown=${user}:${group} neovide.toml ${homedir}/.config/neovide/config.toml
RUN mkdir -p org projects 

USER root
WORKDIR /root

# Setup all env vaiables and aliases for all users
RUN printf "PATH=\"${PATH}\"\n" > /etc/environment && \
printf "DEBIAN_FRONTEND=noninteractive\n" >> /etc/environment && \
printf "LANG=C.UTF-8\n" >> /etc/environment && \
printf "NODE_EXTRA_CA_CERTS="${homedir}"/.certs/cert.pem\n" >> /etc/environment && \
printf "EDITOR=nvim\n" >> /etc/environment && \
printf "TERM=xterm-kitty\n" >> /etc/environment && \
printf "COLORTERM=truecolor\n" >> /etc/environment && \
printf "VISUAL=nvim\n" >> /etc/environment && \
printf "TZ=Asia/Kolkata\n" >> /etc/environment && \
printf "alias ll='ls -alF --color=auto'\n" >> /home/${user}/.config/ezsh/ezshrc.zsh && \
printf "alias la='ls -A --color=auto'\n" >> /home/${user}/.config/ezsh/ezshrc.zsh && \
printf "alias l='ls -CF --color=auto'\n" >> /home/${user}/.config/ezsh/ezshrc.zsh && \
printf "alias kvim='NVIM_APPNAME=kickstart nvim'\n" >> /home/${user}/.config/ezsh/ezshrc.zsh && \
printf "alias lvim='NVIM_APPNAME=lazyvim nvim'\n" >> /home/${user}/.config/ezsh/ezshrc.zsh && \
printf "alias gitdc='gpg --decrypt "${homedir}"/.secrets/gh.gpg'\n" >> /home/${user}/.config/ezsh/ezshrc.zsh && \
printf "alias notesbisync='rclone bisync "${homedir}"/notes mega:notes --resync --size-only'\n" >> /home/${user}/.config/ezsh/ezshrc.zsh && \
printf "alias notessync='rclone sync "${homedir}"/notes mega:notes'\n" >> /home/${user}/.config/ezsh/ezshrc.zsh && \
printf "alias orgbisync='rclone bisync "${homedir}"/org mega:org --resync --size-only'\n" >> /home/${user}/.config/ezsh/ezshrc.zsh && \
printf "alias orgsync='rclone sync "${homedir}"/org mega:notes'\n" >> /home/${user}/.config/ezsh/ezshrc.zsh

EXPOSE 3389
EXPOSE 22
EXPOSE 3000

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/start-xrdp.sh"]
