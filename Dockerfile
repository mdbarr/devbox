FROM ubuntu:focal

ENV LANG="en_US.UTF-8"
ENV TERM="xterm-256color"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        bison \
        build-essential \
        ca-certificates \
        curl \
        emacs \
        emacs-nox \
        flex \
        gdb \
        gettext \
        git  \
        gnupg2 \
        keychain \
        less \
        libtool \
        manpages \
        nano \
        netbase \
        openssh-client \
        powerline \
        shared-mime-info \
        telnet \
        tig \
        tmux \
        uuid \
        wget \
        xauth && \
        curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
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

CMD [ "/bin/bash" ]
