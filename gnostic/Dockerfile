FROM wtfauonabt/protoc_cli

RUN apk add git

## build gnostic
RUN git clone https://github.com/google/gnostic /gnostic

RUN cd /gnostic
RUN make
RUN make test