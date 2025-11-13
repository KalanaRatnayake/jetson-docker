#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM nvcr.io/nvidia/l4t-cuda:12.6.11-runtime AS base

WORKDIR /

RUN apt-get update -y

RUN apt-get install -y --no-install-recommends git \
                                               wget \ 
                                               python3-pip \
                                               libopenblas-dev 

RUN  wget raw.githubusercontent.com/pytorch/pytorch/5c6af2b583709f6176898c017424dc9981023c28/.ci/docker/common/install_cusparselt.sh && \
    export CUDA_VERSION=12.6 && \
    bash ./install_cusparselt.sh

RUN apt-get remove -y python3-numpy 


#####################################################################################
##                           Install PyTorch 2.4
#####################################################################################

RUN wget https://developer.download.nvidia.cn/compute/redist/jp/v61/pytorch/torch-2.5.0a0+872d972e41.nv24.08.17622132-cp310-cp310-linux_aarch64.whl

RUN python3 -m pip install --no-cache-dir 'Cython<3' numpy==1.26.4 torch-2.5.0a0+872d972e41.nv24.08.17622132-cp310-cp310-linux_aarch64.whl

RUN rm torch-2.5.0a0+872d972e41.nv24.08.17622132-cp310-cp310-linux_aarch64.whl

#####################################################################################
##                           Install Torch Vision 0.20
#####################################################################################

RUN git clone --branch v0.20.0 https://github.com/pytorch/vision torchvision

WORKDIR /torchvision

RUN export BUILD_VERSION=0.20.0  && python3 setup.py install

WORKDIR /

RUN rm -rf /torchvision

#####################################################################################
##                           Install Torch Audio 2.5
#####################################################################################

RUN git clone --branch v2.5.0 https://github.com/pytorch/audio torchaudio
    
WORKDIR /torchaudio

RUN python3 -m pip install --no-cache-dir cmake ninja

RUN export BUILD_VERSION=2.5.0  && python3 setup.py install

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

FROM nvcr.io/nvidia/l4t-cuda:12.6.11-runtime as final

COPY --from=base / /

ENV CUDA_HOME="/usr/local/cuda"
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"