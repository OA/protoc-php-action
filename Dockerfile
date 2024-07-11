# todo: automate build and push process
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y build-essential git cmake php

RUN git clone --recursive --depth=1 -b v1.65.0 https://github.com/grpc/grpc

RUN cd grpc && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake ../.. && \
    make protoc grpc_php_plugin && \
    mv grpc_php_plugin /usr/local/bin/ && \
    mv "$(readlink -f third_party/protobuf/protoc)" /usr/local/bin/protoc && \
    cd ../../../ && \
    rm -rf grpc && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
