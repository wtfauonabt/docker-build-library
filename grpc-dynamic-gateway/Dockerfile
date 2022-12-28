FROM node:19-alpine3.15

# Install make gcc
RUN apk add build-base

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# Install grpc-dynamic-gateway
RUN npm install -g grpc-dynamic-gateway

# WORKDIR /working
# COPY . /working
# CMD ["node", "index.js"]