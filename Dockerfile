FROM ubuntu:focal

ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV TERM="xterm-256color"
ENV TZ="America/New_York"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-transport-https \
        autoconf \
        automake \
        bison \
        build-essential \
        ca-certificates \
        curl \
        dnsutils \
        emacs \
        emacs-nox \
        flex \
        gdb \
        gettext \
        git  \
        gnupg2 \
        hexedit \
        iproute2 \
        iputils-ping \
        keychain \
        less \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncurses5-dev \
        libreadline-dev \
        libssh-dev \
        libssl-dev \
        libtool \
        locales \
        locales-all \
        man \
        manpages \
        manpages-dev \
        manpages-posix \
        manpages-posix-dev \
        nano \
        netbase \
        netcat \
        openssh-client \
        powerline \
        python3 \
        python3-dev \
        python3-pip \
        shared-mime-info \
        shellcheck \
        sudo \
        telnet \
        tig \
        tmux \
        uuid \
        vim \
        wget \
        xauth \
        zlib1g-dev && \
        curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
        apt-get update && \
        apt-get install -y nodejs yarn && \
        apt-get autoremove && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
        useradd -m -d /home/mark mark

USER mark
WORKDIR /home/mark

COPY --chown=mark .emacs /home/mark/.emacs
RUN emacs -batch -l /home/mark/.emacs --execute '(kill-emacs)'
RUN echo 'if [ -x "$(command -v yarn)" ]; then\n\
    export PATH="$(yarn global bin):$PATH"\n\
fi\n\
\n\
source /usr/share/powerline/bindings/bash/powerline.sh\n' >> /home/mark/.bashrc
COPY --chown=mark .config /home/mark/.config
COPY --chown=mark .gitconfig /home/mark/.gitconfig

CMD [ "/bin/bash" ]
