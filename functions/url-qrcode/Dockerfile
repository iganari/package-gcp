FROM iganarix/os-ubuntu-18.04

MAINTAINER iganari

## update Package
RUN apt update && \
    apt install -y lsb-release \
                   gnupg

# ref: https://cloud.google.com/sdk/install
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt update && \
    apt install -y google-cloud-sdk


## Install Pip Package
ADD ./requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt
