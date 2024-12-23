# refer:https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-24-09.html
# FROM nvcr.io/nvidia/pytorch:24.10-py3
FROM nvcr.io/nvidia/pytorch:24.06-py3
# refer:https://hub.docker.com/layers/nvidia/cuda/11.8.0-cudnn8-devel-ubuntu22.04/images/sha256-ee127a83b5269251476a3a1933972735a0a8a3269d35fda374f548212687d5db?context=explore
# FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# ENV HOME /home
# ENV PYENV_ROOT $HOME/.pyenv
# ENV PATH $PYENV_ROOT/bin:$PATH

# refer:https://zenn.dev/efficientyk/articles/0fde4dcd4a9520
RUN apt-get update \
    && apt-get install -y \
    git \
    git-lfs \
    curl \
    wget \
    build-essential \
    zlib1g-dev \    
    libncurses5-dev \
    libgdbm-dev \
    libbz2-dev \
    libnss3-dev \
    libsqlite3-dev \
    libssl-dev \
    liblzma-dev \
    libreadline-dev \
    libffi-dev \
    libgl1-mesa-dev \
    locales \
    fish \
    vim \
    nano \
    iputils-ping \
    net-tools \
    software-properties-common \
    fonts-powerline \
    autoconf \
    cmake \
    gdb \
    libboost-system-dev \
    libboost-thread-dev \
    libboost-program-options-dev \
    libboost-test-dev \
    libeigen3-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    pkg-config \
    libgoogle-perftools-dev \
    valgrind \
    flex \
    xclip \
    bison \
    nvtop \
    htop \
    python3.10-venv 

RUN pip install transformers==4.46.2
RUN pip install sentencepiece==0.2.0
RUN pip install datasets==2.20.0
RUN pip install evaluate==0.4.2
RUN pip install accelerate==1.0.1
RUN pip install bitsandbytes==0.44.1
RUN pip install fugashi==1.3.2
RUN pip install mecab-python3==1.0.9
RUN pip install unidic_lite==1.0.8
RUN pip install pykakasi==2.3.0
RUN pip install ipadic==1.0.0
RUN pip install liger_kernel==0.4.0

# RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
#     echo 'eval "$(pyenv init --path)"' >> ~/.bashrc && \
#     echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# # echo '' >> ~/.bashrc
# # echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
# # echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
# # echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
# # source ~/.bashrc

# RUN pyenv install 3.11.6
# RUN pyenv global 3.11.6
