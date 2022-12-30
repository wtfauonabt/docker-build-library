FROM alpine:latest

## Install curl
RUN apk add curl

## Set release version as env
## Download terraform
## Unzip terraform
RUN \
    RELEASE=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`; \
    wget https://releases.hashicorp.com/terraform/${RELEASE}/terraform_${RELEASE}_linux_amd64.zip; \
    unzip terraform_${RELEASE}_linux_amd64.zip;

## Move terraform to bin
RUN mv terraform /usr/bin/terraform

## Add `terraform` CMD as entrypoint
ENTRYPOINT [ "terraform" ]