FROM alpine:3.20.1 AS base

RUN apk add --no-cache libstdc++ libgcc

FROM alpine:3.20.1 AS build

RUN apk add git

WORKDIR /

RUN git clone --recursive --depth=1 --shallow-submodules --jobs 5 -b v1.65.1 https://github.com/grpc/grpc

RUN apk add --no-cache alpine-sdk linux-headers cmake

WORKDIR /grpc

RUN mkdir -p cmake/build && \
    cd cmake/build && \
    cmake ../.. && \
    make protoc grpc_php_plugin && \
    mv grpc_php_plugin /usr/local/bin/ && \
    mv "$(readlink -f third_party/protobuf/protoc)" /usr/local/bin/protoc

FROM base

LABEL org.opencontainers.image.authors="oa"
LABEL org.opencontainers.image.vendor="oa"
LABEL org.opencontainers.image.source="https://github.com/OA/protoc-php-action"
LABEL org.opencontainers.image.documentation="https://github.com/OA/protoc-php-action/blob/main/README.md"
LABEL org.opencontainers.image.title="protoc with php plugin"
LABEL org.opencontainers.image.description="docker image for generating php code from proto files using protoc and grpc_php_plugin"
LABEL org.opencontainers.image.licenses="MIT"

COPY --from=build /usr/local/bin/grpc_php_plugin /usr/local/bin/grpc_php_plugin
COPY --from=build /usr/local/bin/protoc /usr/local/bin/protoc

WORKDIR /project

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
