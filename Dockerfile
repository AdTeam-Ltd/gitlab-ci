FROM buildpack-deps:xenial

MAINTAINER Vladimir N. Dyakov v.dyakov@ad.team

WORKDIR /tmp

# Last packages here:
# https://golang.org/dl/
# https://www.rabbitmq.com/releases/rabbitmq-server/
# https://github.com/Masterminds/glide/releases

ENV RABBIT_VERSION 3.6.6
ENV GO_VERSION 1.8
ENV GLIDE_VERSION 0.12.3

ENV RABBIT_DOWNLOAD_URL https://www.rabbitmq.com/releases/rabbitmq-server/v${RABBIT_VERSION}/rabbitmq-server_${RABBIT_VERSION}-1_all.deb
ENV GO_DOWNLOAD_URL https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz
ENV GLIDE_DOWNLOAD_URL https://github.com/Masterminds/glide/releases/download/v$GLIDE_VERSION/glide-v${GLIDE_VERSION}-linux-amd64.zip

ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure locales

RUN apt-get update
RUN apt-get install --no-install-recommends -y -q \
		    unzip \
		    openssh-client \
		    xvfb \
		    build-essential \
		    make \
		    libssl-dev \
		    libc6-dev \
		    libcurl4-openssl-dev \
		    libreadline-dev \
		    dnsutils \
		    curl \
		    wget \
		    g++ \
		    gcc \
		    git \
		    bzr \
		    git \
		    mercurial \
		    subversion \
		    openssh-client \
		    ca-certificates \
		    erlang-asn1 \
		    erlang-base-hipe \
		    erlang-crypto \
		    erlang-eldap \
		    erlang-inets \
		    erlang-mnesia \
		    erlang-nox \
		    erlang-os-mon \
		    erlang-public-key \
		    erlang-ssl \
		    erlang-xmerl \
		    logrotate \
		    socat \
		    software-properties-common \
		    python-pip \
		    fping \
		    mtr \
		    dnsutils \
		    whois \
		    tcpdump \
		    vim \
		    mc

RUN apt-add-repository ppa:ansible/ansible \
    && apt-get update \
    && apt-get upgrade -y --no-install-recommends \
    && apt-get install -y ansible cron \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN pip install ansible-lint

RUN wget $RABBIT_DOWNLOAD_URL && dpkg -i rabbitmq-server_${RABBIT_VERSION}-1_all.deb && rm rabbitmq-server_${RABBIT_VERSION}-1_all.deb
RUN wget $GO_DOWNLOAD_URL && tar -zxvf go${GO_VERSION}.linux-amd64.tar.gz -C /usr/local && rm go${GO_VERSION}.linux-amd64.tar.gz

RUN curl -fsSL "${GLIDE_DOWNLOAD_URL}" -o glide.zip \
    && unzip glide.zip  linux-amd64/glide \
    && mv linux-amd64/glide /usr/local/bin \
    && rm -rf linux-amd64 \
    && rm glide.zip

#RUN update-rc.d rabbitmq-server defaults
RUN systemctl enable rabbitmq-server.service

RUN apt-get clean -qq
WORKDIR /go
