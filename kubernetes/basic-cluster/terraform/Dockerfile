FROM iganarix/cld-gcloud

ARG _tf_ver='0.12.18'
RUN curl https://releases.hashicorp.com/terraform/${_tf_ver}/terraform_${_tf_ver}_linux_amd64.zip -o /usr/local/bin/terraform_${_tf_ver}_linux_amd64.zip && \
    cd /usr/local/bin/ && \
    unzip terraform_${_tf_ver}_linux_amd64.zip && \
    rm -f /usr/local/bin/terraform_${_tf_ver}_linux_amd64.zip
