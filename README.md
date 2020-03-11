# docker-colab-local
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/aecampos/colab-local.svg?label=build)](https://hub.docker.com/r/aecampos/colab-local)

A Docker container to act as a local runtime for [Google Colab](https://colab.research.google.com) or private jupyter server with BERT preinstalled.

## Run
```bash
$ docker run \
  --runtime=nvidia \
  -it --rm -p 8081:8081 \
  sorokine/docker-colab-local:latest
```
Or, to mount a volume so that it's accessible to colab:
```bash
$ docker run \
  --runtime=nvidia \
  -it --rm -p 8081:8081 \
  -v "$PWD":/opt/colab \
  sorokine/docker-colab-local:latest
```

where `"$PWD"` is a full path on your host machine to put your notebooks (other than the ones hosted on colab) and other files created by the notebooks (e.g., computed indices).

To make downloaded BERT models persistent run as:

```bash
$ docker run \
  --runtime=nvidia \
  -it --rm -p 8081:8081 \
  -v "$PWD":/opt/colab \
  -v $HOME/.cache/torch:/root/.cache/torch \
  sorokine/docker-colab-local:latest
```

This will use the same cache directory as the models run on the host (if your host is Linux or Mac).

## Making Nvidia Work

* on some docker versions replace `--runtime=nvidia` with `--gpus all`.
* if you do not have a GPU or Nvidia drivers installed completely omit all nvidia flags from docker command

* if you do not have the latest CUDA installed on your system check which [tags](https://hub.docker.com/r/sorokine/docker-colab-local/tags) are available in docker hub repo and use the one for your version of CUDA, e.g.:

```bash
$ docker run \
  --runtime=nvidia \
  -it --rm -p 8081:8081 \
  -v "$PWD":/opt/colab \
  -v $HOME/.cache/torch:/root/.cache/torch \
  sorokine/docker-colab-local:10.1
```

* To find the version of CUDA on your system run `nvidia-smi`.  

## Connecting

If the container isn't running on your local machine, you'll need to forward port 8081:
```
$ ssh YOUR_REMOTE_MACHINE -L 8081:localhost:8081
```

In Colaboratory, click the "Connect" button and select "Connect to local runtime...". Enter the port 8081 step in the dialog that appears and click the "Connect" button. (from [colaboratory](https://research.google.com/colaboratory/local-runtimes.html)).  Only `locahost` hostname is accepted (no numberic IPs).  Replace the token in the dialog box with the token that is shown after starting docker container, e.g.: `http://localhost:8081/?token=...`. 


## Notes

* Missing some packages that come with Colab. Install them with `!pip install` in your notebook.

# TODO

plans and pressing ussues will go here
