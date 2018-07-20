FROM ubuntu:xenial

RUN apt-get update

RUN apt-get install -y sudo

ENV DOCKER_USER sly

RUN adduser --disabled-password --gecos '' "$DOCKER_USER"

RUN adduser "$DOCKER_USER" sudo

# Give passwordless sudo. This is only acceptable as it is a private
# development environment not exposed to the outside world. Do NOT do this on
# your host machine or otherwise.
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV USER "$DOCKER_USER"

USER "$DOCKER_USER"

WORKDIR "/home/$DOCKER_USER"

RUN touch ~/.sudo_as_admin_successful

RUN sudo apt-get install -y build-essential

RUN sudo apt-get install -y curl

RUN sudo apt-get install -y git

RUN sudo apt-get install -y openssh-client

RUN sudo apt-get install -y man-db

RUN sudo apt-get install -y bash-completion

RUN sudo apt-get install -y software-properties-common

RUN sudo add-apt-repository ppa:neovim-ppa/unstable

RUN sudo apt-get update

RUN sudo apt-get install neovim -y

ENV EDITOR nvim

RUN mkdir -p "$HOME/.config/nvim"

COPY ./init.vim "/home/$USER/.config/nvim/init.vim"

RUN sudo chown "$USER:$USER" "$HOME/.config/nvim/init.vim"

RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN nvim +PlugInstall +qall

ENV TMUX_VERSION 2.7

ENV TMUX_TAR "tmux-$TMUX_VERSION.tar.gz"

RUN curl -Lo "/tmp/$TMUX_TAR" \
	"https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/$TMUX_TAR"

WORKDIR /tmp

RUN tar -xzf "$TMUX_TAR" -C /tmp

WORKDIR "/tmp/tmux-$TMUX_VERSION"

RUN sudo apt-get install -y libevent-2.0-5 libevent-dev libncurses-dev

RUN ./configure

RUN make

RUN sudo make install

ENV TERM=screen-256color

WORKDIR /home/$DOCKER_USER

COPY ./.tmux.conf "/home/$USER/.tmux.conf"

RUN sudo chown "$USER:$USER" "$HOME/.tmux.conf"
