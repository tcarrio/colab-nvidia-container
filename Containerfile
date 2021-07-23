ARG CUDA_VERSION=10.2

FROM nvidia/cuda:${CUDA_VERSION}-base-ubuntu18.04

LABEL org.opencontainers.image.authors="tom@carrio.dev"

ENV DEBIAN_FRONTEND=noninteractive
ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket
ENV PULSE_SERVER=unix:/run/pulse/pulseaudio.socket

# install Python
ARG _PY_SUFFIX=3
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

#WORKDIR /opt/colab
WORKDIR /content

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf && \
    echo 'APT::Get::allow-yes "true";' >> /etc/apt/apt.conf && \
    apt-get update && apt-get -y dist-upgrade && \
    apt-get install sudo unzip curl unrar p7zip-full software-properties-common git wget net-tools && \
    apt-get install -y ${PYTHON} ${PYTHON}-pip && \
    ${PIP} --no-cache-dir install --upgrade pip setuptools && \
    ln -s $(which ${PYTHON}) /usr/local/bin/python && \
    python -m pip --no-cache-dir install --upgrade pip setuptools && \
    apt-get install -y python python-pip && \
    mkdir -p /opt/colab /var/colab /content && \
    pip install jupyterlab jupyter_http_over_ws ipywidgets https://github.com/googlecolab/colabtools/archive/main.zip && \
    jupyter serverextension enable --py jupyter_http_over_ws && \
    jupyter nbextension enable --py widgetsnbextension

# install task-specific packages
# RUN pip install pytorch-pretrained-bert sklearn transformers matplotlib 
# RUN pip install --upgrade tensorflow

# I do not know exactly why but annoy has to be installed seprately from other pips, otherwise it crashes the kernel
#RUN pip install annoy

RUN IMP='&\n        from google.colab._shell import Shell'; \
    sed -i "s/def system_piped(s.*/$IMP/;s/def getoutput(s.*/$IMP/;s/system(self.v/Shell().&/;s/getoutput(self.v.*))/Shell().&[0]/" /usr/local/lib/python3.6/dist-packages/IPython/core/interactiveshell.py

RUN pip install psutil gdown

ARG COLAB_PORT=8081
EXPOSE ${COLAB_PORT}
ENV COLAB_PORT ${COLAB_PORT}
ENV ALLOWED_ORIGIN https://colab.research.google.com

CMD jupyter notebook \
    --NotebookApp.allow_origin='$ALLOWED_ORIGIN' \
    --allow-root \
    --port $COLAB_PORT \
    --NotebookApp.port_retries=0 \
    --ip 0.0.0.0 \
    --NotebookApp.token='' \
    --NotebookApp.disable_check_xsrf=True > server.log 2>&1
