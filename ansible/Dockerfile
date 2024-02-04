# Dockerfile for ansible
# Version: 1.0
# Author: wtfauonabt 
# Date: 2024-01-21
# Description: Ansible Dockerfile

# Pull base image.
FROM ubuntu:20.04

# Set environment variables.
ENV ANSIBLE_VERSION 2.16.2

# Install Ansible.
RUN apt-get update; \
    apt-get install -y \
        gcc \
        python3 \
        python3-pip; \
    apt-get clean all
RUN pip3 install --upgrade pip; \
    pip3 install "ansible==${ANSIBLE_VERSION}"; \
    pip3 install ansible;

# Install Inifical
RUN apt-get update; \
    apt-get install -y \
        bash \
        curl; \
    apt-get clean all

RUN curl -1sLf 'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.deb.sh' | bash 

RUN apt-get update \
    && apt-get install -y infisical \
    && apt-get clean all


CMD ["infisical", "run"]