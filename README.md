# docker-datalevin

Docker image for [Datalevin database](https://github.com/datalevin/datalevin).

## Run as a server

Data will be stored under a volume called `/data` in the container, make sure that this volume is linked to the host when running the container if you want the data to be persistent, e.g. `-v /whatever/on/host:/data`.

By default, the server listen to port 8898. An environment variable `DATALEVIN_PORT` can be set to an alternative port. For example,

```console
docker run --env DATALEVIN_PORT=8899 -p 8899:8899 -v /tmp/data:/data huahaiy/datalevin
```
This will run the Datalevin server, with data in /tmp/data on your host, and listening to port 8899.

The server runs the JVM version of Datalevin as it is suitable for long running process.

## Run as a shell command

This will enter the Datalevin REPL:

```console
 docker run -i  huahaiy/datalevin dtlv
```

This will show Datalevin help screen.

```console
 docker run huahaiy/datalevin dtlv help
```

Shell command runs the GraalVM native image version of Datalevin as it has fast startup.

## Building and publishing multi-platform images

The image supports `linux/amd64` and `linux/arm64` under a single tag. Docker
automatically selects the matching architecture when pulling the image.

The default Java 21 runtime matches each native release binary:

| Platform | Runtime image | Ubuntu release |
| --- | --- | --- |
| `linux/amd64` | `eclipse-temurin:21-jre-jammy` | 22.04 |
| `linux/arm64` | `eclipse-temurin:21-jre-noble` | 24.04 |

The `ubuntu-22.04` part of an asset filename does not select the container's
base image; the Dockerfile selects it from the target architecture. An explicit
`JAVA_IMAGE` build argument overrides that selection and must be compatible
with the corresponding native binary.

Use [Docker Buildx](https://docs.docker.com/build/building/multi-platform/) to
build both platforms and publish them together. Create a builder once:

```console
docker buildx create --name datalevin-builder --driver docker-container --bootstrap
```

Docker Desktop includes support for emulating the other architecture. On a
standalone Linux host, the builder needs emulation support or native nodes for
both platforms; see the Docker Buildx documentation linked above.

Log in to Docker Hub, then build and push a version (the Dockerfile defaults to
Datalevin 1.2.10):

```console
docker login
docker buildx build --builder datalevin-builder --pull \
  --platform linux/amd64,linux/arm64 \
  --build-arg DATALEVIN_VERSION=1.2.10 \
  --tag huahaiy/datalevin:1.2.10 \
  --push .
```

To also update `latest`, add `--tag huahaiy/datalevin:latest` to the build command.
The `--push` option publishes both images and their shared manifest in one step.
Verify the published platforms with:

```console
docker buildx imagetools inspect huahaiy/datalevin:1.2.10
```

For a local multi-platform build with Docker's containerd image store enabled,
use the default builder and load both platforms without publishing:

```console
docker buildx build --builder default --pull \
  --platform linux/amd64,linux/arm64 \
  --build-arg DATALEVIN_VERSION=1.2.10 \
  --tag huahaiy/datalevin:1.2.10 \
  --load .
docker run --rm --platform linux/amd64 huahaiy/datalevin:1.2.10 dtlv help
docker run --rm --platform linux/arm64 huahaiy/datalevin:1.2.10 dtlv help
```

With Docker's classic image store, use the `datalevin-builder` builder with a
single `--platform` and `--load` to test each architecture locally.
