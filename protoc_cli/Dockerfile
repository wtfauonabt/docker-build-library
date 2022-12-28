# FROM alpine

# ENV PB_REL="https://github.com/protocolbuffers/protobuf/releases"

# RUN curl -LO $PB_REL/download/v3.15.8/protoc-3.15.8-linux-x86_64.zip
# RUN unzip protoc-3.15.8-linux-x86_64.zip -d $HOME/.local

# ENV PATH="$PATH:$HOME/.local/bin"

FROM golang:alpine

RUN apk update
RUN apk add --no-cache make protobuf-dev

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

ENV PATH="$PATH:$(go env GOPATH)/bin"

# # Install protoc (cf. http://google.github.io/proto-lens/installing-protoc.html)
# ENV PROTOC_ZIP=protoc-3.13.0-linux-x86_64.zip
# RUN apt-get update && apt-get install -y unzip
# RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/$PROTOC_ZIP \
#     && unzip -o $PROTOC_ZIP -d /usr/local bin/protoc \
#     && unzip -o $PROTOC_ZIP -d /usr/local 'include/*' \ 
#     && rm -f $PROTOC_ZIP


