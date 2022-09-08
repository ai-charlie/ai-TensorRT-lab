#!/usr/bin/env bash

rm /etc/apt/sources.list.d/cuda.list
rm /etc/apt/sources.list.d/nvidia-ml.list
apt-key del 7fa2af80
apt-get update && apt-get install -y --no-install-recommends wget
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
dpkg -i cuda-keyring_1.0-1_all.deb

apt-get update && apt-get install -y software-properties-common
add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    zlib1g-dev \
    git \
    pkg-config \
    sudo \
    ssh \
    libssl-dev \
    pbzip2 \
    pv \
    bzip2 \
    unzip \
    devscripts \
    lintian \
    fakeroot \
    dh-make \
    build-essential \
    git-lfs

apt-get install -y --no-install-recommends \
      python3 \
      python3-pip \
      python3-dev \
      python3-wheel &&\
    cd /usr/local/bin &&\
    ln -s /usr/bin/python3 python &&\
    ln -s /usr/bin/pip3 pip;

pip3 install --upgrade pip
pip3 config set global.index-url https://pypi.douban.com/simple/
pip3 install setuptools>=41.0.0

pip3 install -r requirements.txt

# Install jupyter
pip3 install jupyter jupyterlab
# Workaround to remove numpy installed with tensorflow
pip3 install --upgrade numpy
pip3 install ipykernel
pip3 install ipywidgets --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org
jupyter nbextension enable --py widgetsnbextension


cd /tmp && \
    wget https://github.com/Kitware/CMake/releases/download/v3.14.4/cmake-3.14.4-Linux-x86_64.sh && \
    chmod +x cmake-3.14.4-Linux-x86_64.sh && \
    ./cmake-3.14.4-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir --skip-license && \
    rm ./cmake-3.14.4-Linux-x86_64.sh

apt-get install libnvinfer8 libnvonnxparsers8 libnvparsers8 libnvinfer-plugin8 libnvinfer-dev libnvonnxparsers-dev libnvparsers-dev libnvinfer-plugin-dev python3-libnvinfer

apt-mark hold libnvinfer8 libnvonnxparsers8 libnvparsers8 libnvinfer-plugin8 libnvinfer-dev libnvonnxparsers-dev libnvparsers-dev libnvinfer-plugin-dev python3-libnvinfer