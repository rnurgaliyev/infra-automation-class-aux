FROM hashicorp/packer:1.1.0

RUN apk add --no-cache ruby python py-pip py-setuptools python-dev openssl-dev \
        libffi-dev build-base ruby-dev ruby-rdoc ruby-irb openssh-client && \
    pip install ansible && \
    apk del libffi-dev build-base ruby-dev py-pip python-dev openssl-dev && \
    rm -rf /var/cache/apk/*
