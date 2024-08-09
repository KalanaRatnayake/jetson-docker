#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM nvcr.io/nvidia/l4t-jetpack:r36.3.0 AS base

WORKDIR /

RUN apt-get update -y

RUN apt-get install -y --no-install-recommends git wget

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/arm64/cuda-keyring_1.1-1_all.deb

RUN dpkg -i cuda-keyring_1.1-1_all.deb
 
RUN apt-get update -y

RUN apt-get -y install --no-install-recommends python3-pip \
                                               libpython3-dev \
                                               libopenblas-dev \
                                               libopenblas-base \
                                               libopenmpi-dev \
                                               openmpi-common \
                                               gfortran \
                                               libomp-dev \
                                               libcusparselt0 \
                                               libcusparselt-dev \
                                               libjpeg-dev \
                                               zlib1g-dev \
                                               libavcodec-dev \
                                               libavformat-dev \
                                               libswscale-dev

RUN apt-get remove -y python3-numpy 

#####################################################################################
##                           Install PyTorch 2.4
#####################################################################################

RUN wget https://developer.download.nvidia.cn/compute/redist/jp/v60/pytorch/torch-2.4.0a0+3bcc3cddb5.nv24.07.16234504-cp310-cp310-linux_aarch64.whl 

RUN python3 -m pip install --no-cache-dir 'Cython<3' numpy==1.26.4 torch-2.4.0a0+3bcc3cddb5.nv24.07.16234504-cp310-cp310-linux_aarch64.whl

RUN rm torch-2.4.0a0+3bcc3cddb5.nv24.07.16234504-cp310-cp310-linux_aarch64.whl

#####################################################################################
##                           Install Torch Vision 0.19
#####################################################################################

RUN git clone --branch v0.19.0 https://github.com/pytorch/vision torchvision

WORKDIR /torchvision

RUN export BUILD_VERSION=0.19.0  && python3 setup.py install

WORKDIR /

RUN rm -rf /torchvision

#####################################################################################
##                           Install Torch Audio 2.4
#####################################################################################

RUN git clone --branch v2.4.0 https://github.com/pytorch/audio torchaudio

WORKDIR /torchaudio

RUN export BUILD_VERSION=2.4.0  && python3 setup.py install

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

FROM scratch as final

COPY --from=base / /

ENV CUDA_HOME="/usr/local/cuda"
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"