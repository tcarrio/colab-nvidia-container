# docker-colab-local
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/aecampos/colab-local.svg?label=build)](https://hub.docker.com/r/aecampos/colab-local)

A Docker container to act as a local runtime for [Google Colab](https://colab.research.google.com) or private jupyter server with BERT preinstalled.

## Run
```bash
$ docker run --runtime=nvidia -it --rm -p 8081:8081 sorokine/docker-colab-local:latest
```
Or, to mount a volume so that it's accessible to colab:
```bash
$ docker run --runtime=nvidia -it --rm -p 8081:8081 -v /host/directory:/opt/colab sorokine/docker-colab-local:latest
```

where `/host/directory` is a path on your host machine to put your notebooks.

To make downloaded BERT models persistent run as:

```bash
$ docker run --runtime=nvidia -it --rm -p 8081:8081 -v /host/directory:/opt/colab -v $HOME/.cache/torch:/root/.cache/torch sorokine/docker-colab-local:latest
```

This will use the same cache directory as the models run on the host (if your host is Linux or Mac).

## Connecting
If the container isn't running on your local machine, you'll need to forward port 8081:
```
$ ssh YOUR_REMOTE_MACHINE -L 8081:localhost:8081
```

In Colaboratory, click the "Connect" button and select "Connect to local runtime...". Enter the port 8081 step in the dialog that appears and click the "Connect" button. (from [colaboratory](https://research.google.com/colaboratory/local-runtimes.html))


## Notes

* Missing some packages that come with Colab. Install them with `!pip install` in your notebook.

# TODO

 - [ ] use build args instead branches for images for different platforms and CUDA versions
