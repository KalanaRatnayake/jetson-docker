#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM nvcr.io/nvidia/l4t-jetpack:r36.3.0 AS base

WORKDIR /

RUN apt-get update -y

RUN apt-get install -y --no-install-recommends git wget

#####################################################################################
##                           Install PyTorch 2.4
#####################################################################################

RUN wget https://developer.download.nvidia.cn/compute/redist/jp/v60/pytorch/torch-2.4.0a0+3bcc3cddb5.nv24.07.16234504-cp310-cp310-linux_aarch64.whl

RUN apt-get install -y --no-install-recommends python3-pip libopenblas-base libopenmpi-dev libomp-dev

RUN python3 -m pip install --no-cache-dir 'Cython<3'

RUN python3 -m pip install --no-cache-dir numpy torch-2.4.0a0+3bcc3cddb5.nv24.07.16234504-cp310-cp310-linux_aarch64.whl

RUN rm torch-2.4.0a0+3bcc3cddb5.nv24.07.16234504-cp310-cp310-linux_aarch64.whl

#####################################################################################
##                           Install Torch Vision 0.18
#####################################################################################

RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev libpython3-dev libopenblas-dev libavcodec-dev libavformat-dev libswscale-dev

RUN git clone --branch v0.19.0 https://github.com/pytorch/vision torchvision   # see below for version of torchvision to download

WORKDIR /torchvision

RUN export BUILD_VERSION=0.19.0  && python3 setup.py install --user

WORKDIR /

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