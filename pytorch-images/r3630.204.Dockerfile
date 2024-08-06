#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM nvcr.io/nvidia/l4t-base:r36.2.0 AS base

WORKDIR /

######################################################################################
##                           Install dependencies
######################################################################################

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends python3-pip \
                                               libpython3-dev \
                                               libjpeg-dev \
                                               libopenblas-dev \
                                               libopenmpi-dev \
                                               libomp-dev \
                                               libavcodec-dev \
                                               libavformat-dev \
                                               libswscale-dev \
                                               zlib1g-dev

RUN python3 -m pip install  --no-cache-dir  future \
                                            wheel \
                                            mock \
                                            pillow \
                                            testresources \
                                            setuptools==58.3.0 \
                                            Cython \
                                            gdown \
                                            protobuf

#####################################################################################
##                           Install PyTorch 1.13.0
#####################################################################################

RUN python3 -m pip install --no-cache-dir torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 --index-url https://download.pytorch.org/whl/cu121

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