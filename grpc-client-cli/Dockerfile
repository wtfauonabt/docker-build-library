########################################################################################
## Build docker image in alpine that can run grpc-client-cli installed with go
########################################################################################

FROM golang

# Install required packages
#RUN apk add --no-cache bash curl git go make protobuf protobuf-dev protoc

# Set go environment variables
#ENV GOPATH /go
#ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Install grpc-client-cli
RUN go install github.com/vadimi/grpc-client-cli/cmd/grpc-client-cli@latest

# Set working directory
#WORKDIR /go/src

CMD ["/bin/bash"]
#CMD ["grpc-client-cli"]
