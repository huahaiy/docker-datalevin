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

## Building and publishing docker

The default Java 21 runtime matches each native release binary:

| Platform | Runtime image | Ubuntu release |
| --- | --- | --- |
| `linux/amd64` | `eclipse-temurin:21-jre-jammy` | 22.04 |
| `linux/arm64` | `eclipse-temurin:21-jre-noble` | 24.04 |

The `ubuntu-22.04` part of an asset filename does not select the container's
base image; the Dockerfile selects it from the target architecture. An explicit
`JAVA_IMAGE` build argument overrides that selection and must be compatible
with the corresponding native binary.

To build the docker image (the Dockerfile defaults to Datalevin 1.2.9):

```console
docker build --pull --platform=linux/amd64 --build-arg DATALEVIN_VERSION=<version> -t huahaiy/datalevin:<version> .
```

And to publish

```console
docker push huahaiy/datalevin:<version>
```
