FROM ubuntu:bionic

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        bison \
        build-essential \
        ca-certificates \
        curl \
        emacs25-el \
        emacs25-nox \
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
        shared-mime-info \
        telnet \
        tmux \
        wget \
        xauth && \
        curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
        apt-get update && \
        apt-get install -y nodejs yarn && \
        apt-get autoremove && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
        npm install -g forever fx && \
        useradd -m -d /home/mark mark

USER mark
WORKDIR /home/mark
CMD [ "/bin/bash" ]
