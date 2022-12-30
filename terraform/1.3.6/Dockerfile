FROM alpine:latest

## Install curl
RUN apk add curl

## Set release version as env
ENV RELEASE=1.3.6

## Download terraform
RUN wget https://releases.hashicorp.com/terraform/${RELEASE}/terraform_${RELEASE}_linux_amd64.zip

## Unzip terraform
RUN unzip terraform_${RELEASE}_linux_amd64.zip

## Move terraform to bin
RUN mv terraform /usr/bin/terraform

## Add `terraform` CMD as entrypoint
ENTRYPOINT [ "terraform" ]