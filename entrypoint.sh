#!/bin/sh -l

mkdir -p "$1" "$2"

protoc --php_out="$1" \
  --grpc_out="$2" \
  --plugin=protoc-gen-grpc="$(which grpc_php_plugin)" \
  "$(find "$3"/ -iname "*.proto")"
