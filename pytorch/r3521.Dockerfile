#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM nvcr.io/nvidia/l4t-cuda:12.2.12-runtime AS base

WORKDIR /

RUN apt-get update -y

RUN apt-get install -y --no-install-recommends git wget

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/arm64/cuda-keyring_1.1-1_all.deb

RUN dpkg -i cuda-keyring_1.1-1_all.deb
 
RUN apt-get update -y

RUN apt-get -y install --no-install-recommends python3-pip \
                                               libopenblas-base \
                                               libopenblas-dev \
                                               libopenmpi-dev \
                                               libomp-dev \
                                               libjpeg-dev \
                                               zlib1g-dev \
                                               libpython3-dev \
                                               libavcodec-dev \
                                               libavformat-dev \
                                               libswscale-dev

RUN apt-get remove -y python3-numpy 

#####################################################################################
##                           Install PyTorch 2.1
#####################################################################################

RUN wget https://developer.download.nvidia.cn/compute/redist/jp/v512/pytorch/torch-2.1.0a0+41361538.nv23.06-cp38-cp38-linux_aarch64.whl

RUN python3 -m pip install --no-cache-dir 'Cython<3' numpy torch-2.1.0a0+41361538.nv23.06-cp38-cp38-linux_aarch64.whl

RUN rm torch-2.1.0a0+41361538.nv23.06-cp38-cp38-linux_aarch64.whl

#####################################################################################
##                           Install Torch Vision 0.16
#####################################################################################

RUN git clone --branch v0.16.0 https://github.com/pytorch/vision torchvision

WORKDIR /torchvision

RUN export BUILD_VERSION=0.16.0  && python3 setup.py install

WORKDIR /

RUN rm -rf /torchvision

#####################################################################################
##                           Install Torch Audio 2.1
#####################################################################################

RUN git clone --branch v2.1.0 https://github.com/pytorch/audio torchaudio

WORKDIR /torchaudio

RUN python3 -m pip install --no-cache-dir cmake ninja

RUN export BUILD_VERSION=2.1.0  && python3 setup.py install

WORKDIR /

RUN rm -rf /torchaudio

#####################################################################################
##
##   Remove dev packages to reduce size
##
#####################################################################################

RUN apt-get update -y

RUN apt-get autoremove -y

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

RUN apt-get clean

#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start final release image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM nvcr.io/nvidia/l4t-cuda:12.2.12-devel AS final

COPY --from=base / /

ENV CUDA_HOME="/usr/local/cuda"
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"