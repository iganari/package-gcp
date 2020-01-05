FROM iganarix/cld-gcloud

ARG tf_ver='0.12.18'
RUN curl https://releases.hashicorp.com/terraform/${tf_ver}/terraform_${tf_ver}_linux_amd64.zip -o /usr/local/bin/terraform_${tf_ver}_linux_amd64.zip && \
    cd /usr/local/bin/ && \
    unzip terraform_${tf_ver}_linux_amd64.zip && \
    rm -f /usr/local/bin/terraform_${tf_ver}_linux_amd64.zip