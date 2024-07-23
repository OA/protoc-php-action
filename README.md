# protoc php action

this action runs the protoc compiler with the php plugin.

## example usage

### github action

```yaml
name: build

on:
  release:
    types: [ published ]

permissions: write-all

env:
  ARTIFACT_NAME: generated-artifact.zip

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: checkout repository
        uses: actions/checkout@v4

      - name: compile proto files
        uses: oa/protoc-php-action@0.2.2
        with:
          php-out: client/target
          grpc-out: client/target
          proto-file-directory: proto

      - name: archive composer package with generated files
        run: zip -r $ARTIFACT_NAME client

      - name: release
        uses: softprops/action-gh-release@v2
        with:
          files: ${{ env.ARTIFACT_NAME }}
```

### docker run

```shell
docker run --rm -v $(pwd):/project ghcr.io/oa/protoc-php-action:0.2.2 client/target client/target proto
```
