# docker-datalevin

Docker image for Datalevin database.

## Run as a server

Data will be stored under a volume called `/data` in the container, make sure that this volume is linked to the host when running the container if you want the data to be persistent, e.g. `-v /whatever/on/host:/data`. Also remember to expose the port. For example:

```console
docker run -p 8898:8898 -v /tmp/data:/data huahaiy/datalevin
```
This will run the Datalevin server, with data in /tmp/data on your host, and listening to port 8898.

## Run as a shell command

This will enter the Datalevin REPL:

```console
 docker run -i  huahaiy/datalevin dtlv
```

This will show Datalevin help screen.

```console
 docker run huahaiy/datalevin dtlv help
```
