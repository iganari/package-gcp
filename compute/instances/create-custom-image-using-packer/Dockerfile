ARG _TAG='290.0.0-alpine'
FROM google/cloud-sdk:${_TAG}
# https://hub.docker.com/r/google/cloud-sdk/tags?page=1&name=-alpine

# setting timezone
RUN apk --update add tzdata \
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

# install git
RUN apk --update add vim git ansible \
    && rm -rfv /var/lib/apt/lists/* \
    && rm -rfv /var/cache/apk/*

RUN mkdir /usr/src \
    && wget https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_linux_amd64.zip \
    && unzip packer_1.5.5_linux_amd64.zip \
    && mv packer /usr/local/bin/packer \
    && rm -fv packer_1.5.5_linux_amd64.zip