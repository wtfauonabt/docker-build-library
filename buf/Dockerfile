FROM bufbuild/buf

## Install NodeJS
RUN apk add --update \
    nodejs \
    npm \
    go

WORKDIR /go/src
RUN git clone \
    --depth 1  \
    --filter=blob:none  \
    --sparse \
    https://github.com/googleapis/googleapis.git \
    ;
WORKDIR /go/src/googleapis
RUN git sparse-checkout set google/api

## Install protobuf
RUN apk update
RUN apk add --no-cache make protobuf-dev
# Install from source
# ENV PROTOC_ZIP=protoc-3.13.0-linux-x86_64.zip
# RUN apt-get update && apt-get install -y unzip
# RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/$PROTOC_ZIP \
#     && unzip -o $PROTOC_ZIP -d /usr/local bin/protoc \
#     && unzip -o $PROTOC_ZIP -d /usr/local 'include/*' \ 
#     && rm -f $PROTOC_ZIP
# ENV PATH="$PATH:$(go env GOPATH)/bin"

## Go Generator
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
## gRPC Gateway Generator
RUN go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
RUN go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest

WORKDIR /workspace
ENV PATH="$PATH:/root/go/bin"