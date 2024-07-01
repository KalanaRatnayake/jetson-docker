#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM ghcr.io/kalanaratnayake/foxy-base:r32.7.1 as base

WORKDIR /

RUN apt-get update -y
RUN apt-get install  -y --no-install-recommends python3-pip \
                                                cmake \
                                                git  \
                                                libopenblas-dev \
                                                libopenmpi-dev \
                                                libjpeg-dev \
                                                zlib1g-dev \
                                                libpython3-dev \
                                                libavcodec-dev \
                                                libavformat-dev \
                                                libswscale-dev

######################################################################################
##                           Install pytorch
######################################################################################

WORKDIR /

RUN git clone --recursive --branch v1.12.0 http://github.com/pytorch/pytorch

WORKDIR /pytorch

ENV USE_NCCL=0
ENV USE_QNNPACK=0
ENV USE_PYTORCH_QNNPACK=0
ENV TORCH_CUDA_ARCH_LIST="5.3;6.2;7.2"

# skip setting this if you want to enable OpenMPI backend
ENV USE_DISTRIBUTED=0

ENV PYTORCH_BUILD_VERSION=1.12.0
ENV PYTORCH_BUILD_NUMBER=1

RUN pip3 install --ignore-installed --upgrade --no-cache-dir -r requirements.txt \
                                                                scikit-build \
                                                                ninja

RUN python3 setup.py bdist_wheel


######################################################################################
##                           Install pytorch vision
######################################################################################

WORKDIR /

RUN git clone --branch v0.13.0 https://github.com/pytorch/vision

WORKDIR /torchvision

ENV BUILD_VERSION=0.13.0

RUN python3 setup.py install --user


######################################################################################
##                           Install pytorch audio
######################################################################################

WORKDIR /

RUN git clone --branch v0.12.0 https://github.com/pytorch/audio

WORKDIR /torchaudio

ENV BUILD_VERSION=0.12.0

RUN python3 setup.py install --user


# WORKDIR /

# RUN rm -rf /pytorch

#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start final release image
#----
#---------------------------------------------------------------------------------------------------------------------------
    
FROM ghcr.io/kalanaratnayake/humble_ros_core:r32.7.1 as final

COPY --from=base / /