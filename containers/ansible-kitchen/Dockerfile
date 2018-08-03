FROM alpine:latest

RUN apk add --no-cache ruby python py-pip py-setuptools python-dev openssl-dev \
        libffi-dev build-base ruby-dev ruby-rdoc ruby-irb openssh-client && \
    pip install ansible==2.4.3.0 testinfra && \
    gem install test-kitchen && \
    gem install kitchen-openstack && \
    gem install kitchen-ansiblepush && \
    apk del libffi-dev build-base ruby-dev py-pip python-dev openssl-dev && \
    rm -rf /var/cache/apk/*
