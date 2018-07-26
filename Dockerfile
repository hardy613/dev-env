ARG DEV_ENV_VERSION=18.07.25

ARG UBUNTU_RELEASE=xenial

FROM ubuntu:${UBUNTU_RELEASE}

RUN apt-get update && apt-get install -y sudo

ENV DOCKER_USER sly613

# remove sudo password
RUN adduser --disabled-password --gecos '' "$DOCKER_USER" && \
	adduser "$DOCKER_USER" sudo && \
# Give passwordless sudo. This is only acceptable as it is a private
# development environment not exposed to the outside world. Do NOT do this on
# your host machine or otherwise.
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
# remove the notification
	touch ~/.sudo_as_admin_successful

# env for build and for container
ENV USER "$DOCKER_USER"

USER "$DOCKER_USER"

ENV HOME "/home/$USER"

WORKDIR "$HOME"

# tools
RUN sudo apt-get install -y build-essential && \
	sudo apt-get install -y cmake && \
	sudo apt-get install -y curl && \
	sudo apt-get install -y git && \
	sudo apt-get install -y openssh-client && \
	sudo apt-get install -y man-db && \
	sudo apt-get install -y bash-completion && \
	sudo apt-get install -y software-properties-common

# tmux
ENV TMUX_VERSION 2.7

ENV TMUX_TAR "tmux-$TMUX_VERSION.tar.gz"

RUN curl -Lo "/tmp/$TMUX_TAR" \
	"https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/$TMUX_TAR"

WORKDIR /tmp

RUN tar -xzf "$TMUX_TAR" -C /tmp

WORKDIR "/tmp/tmux-$TMUX_VERSION"

RUN sudo apt-get install -y libevent-2.0-5 libevent-dev libncurses-dev && \
	./configure && \
	make && \
	sudo make install

ENV TERM=screen-256color

WORKDIR "$HOME"

COPY ./.tmux.conf "$HOME/.tmux.conf"

RUN sudo chown "$USER:$USER" "$HOME/.tmux.conf"

# node LTS
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

ENV NVM_DIR $HOME/.nvm

RUN . ~/.nvm/nvm.sh && nvm install --lts && nvm alias default stable

# rust nightly
# Install openssl/pkgconf to compile against for reqwest and Iron.
RUN sudo apt-get update && \
	sudo apt-get install pkgconf libssl-dev --no-install-recommends -y && \
	curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly

ENV RUST_DEFAULT_TOOLCHAIN='nightly'

RUN git clone https://github.com/ticki/dybuk.git && \
	. $HOME/.cargo/env && \
	cargo install cargo-watch && \
	rustup component add rust-src --toolchain nightly && \
	cargo install --path dybuk && \
	rm -rf dybuk

# python
RUN sudo apt-get install -y python3-pip && \
	sudo pip3 install --upgrade pip && \
	sudo pip3 install flake8 jedi virtualenv ptpython neovim && \
	sudo apt-get update && \
	sudo apt-get install -y --no-install-recommends python3-dev

# nvim
RUN sudo add-apt-repository ppa:neovim-ppa/unstable && \
	sudo apt-get update && \
	sudo apt-get install neovim -y && \
	mkdir -p "$HOME/.config/nvim"

ENV EDITOR nvim
# nvim plugins
COPY ./init.vim "$HOME/.config/nvim/init.vim"

RUN sudo chown "$USER:$USER" "$HOME/.config/nvim/init.vim" && \
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
	nvim +PlugInstall +qall && \
# youCompleteMe
	. ~/.nvm/nvm.sh && \
	. $HOME/.cargo/env && \
	python3 ~/.config/nvim/plugged/YouCompleteMe/install.py \
	--js-completer --rust-completer

# enable tern support
COPY ./.tern-config "$HOME/.tern-config"

RUN sudo chown "$USER:$USER" "$HOME/.tern-config"

# .bashrc alias
COPY ./.bashrc /tmp/.bashrc

RUN sudo cat /tmp/.bashrc >> "$HOME/.bashrc" && \
# clean up
	sudo apt-get clean && \
	sudo rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
