FROM nvidia/cuda:10.2-base-ubuntu18.04

MAINTAINER Adrian Campos "https://github.com/adriancampos"

# install Python
ARG _PY_SUFFIX=3
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y \
    ${PYTHON} \
    ${PYTHON}-pip

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

RUN ln -s $(which ${PYTHON}) /usr/local/bin/python


RUN mkdir -p /opt/colab

WORKDIR /opt/colab

#COPY requirements.txt .

#RUN pip install -r requirements.txt \
RUN pip install jupyterlab jupyter_http_over_ws ipywidgets google-colab\
    && jupyter serverextension enable --py jupyter_http_over_ws \
    && jupyter nbextension enable --py widgetsnbextension

# install task-specific packages
RUN pip install pytorch-pretrained-bert sklearn transformers matplotlib
#RUN pip install google-colab

EXPOSE 8081

CMD ["jupyter","notebook","--NotebookApp.allow_origin='https://colab.research.google.com'","--allow-root","--port","8081","--NotebookApp.port_retries=0","--ip","0.0.0.0"]
