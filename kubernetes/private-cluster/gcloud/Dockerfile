ARG _TAG='286.0.0-alpine'
FROM google/cloud-sdk:${_TAG}
# https://hub.docker.com/r/google/cloud-sdk/

MAINTAINER iganari

# setting timezone
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

# install package
RUN apk --update add git bind-tools && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apk/*

# Install kubectl binary via curl
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-via-curl
# https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV _KUBECTL_VERSION='v1.18.0'

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${_KUBECTL_VERSION}/bin/linux/amd64/kubectl \
         -o /usr/local/bin/kubectl &&\
    chmod 0755 /usr/local/bin/kubectl

# update gcloud
RUN gcloud components update && \
    gcloud components install beta
