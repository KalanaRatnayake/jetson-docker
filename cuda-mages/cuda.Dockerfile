#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM ubuntu:18.04 as base

#############################################################################################################################
#####
##### Install CUDA 10.2 and CUDNN 7.6 . Increases the image size by about 2.5GB. Need to figure out how to reduce this bloat.
#####
#############################################################################################################################

# Packages versions
ENV CUDA_VERSION=10.2.89
ENV CUDA_PKG_VERSION=10-2=10.2.89-1
ENV NCCL_VERSION=2.5.6
ENV CUDNN_VERSION=7.6.5.32

# add the CUDA deb repo to the apt sources list
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends gnupg2 curl ca-certificates

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub

RUN echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list
RUN echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

# Install runtime and devel cuda and CUDNN7

RUN apt-get update -y   
RUN apt-get install -y --no-install-recommends cuda-cudart-${CUDA_PKG_VERSION} \
                                               cuda-libraries-${CUDA_PKG_VERSION} \
                                               cuda-command-line-tools-${CUDA_PKG_VERSION} \
                                               cuda-minimal-build-${CUDA_PKG_VERSION} \
                                               libnccl2=${NCCL_VERSION}-1+cuda10.2 \
                                               libcudnn7=${CUDNN_VERSION}-1+cuda10.2 \
                                               cuda-nvml-dev-${CUDA_PKG_VERSION} \
                                               cuda-libraries-dev-${CUDA_PKG_VERSION} \
                                               libnccl-dev=${NCCL_VERSION}-1+cuda10.2 \
                                               libcudnn7-dev=${CUDNN_VERSION}-1+cuda10.2

RUN ln -s cuda-10.2 /usr/local/cuda
RUN apt-mark hold libnccl2 libcudnn7
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean


############################################################################################################################
#####
#####   Custom code goes here (eg. Opencv)
#####
#############################################################################################################################




#############################################################################################################################
#####
#####   Remove dev packages to reduce size
#####
#############################################################################################################################

RUN apt-get update -y

# CUDA and CUDNN packages
RUN apt-get purge --yes cuda-nvml-dev-${CUDA_PKG_VERSION} \
                        cuda-libraries-dev-${CUDA_PKG_VERSION} \
                        libnccl-dev=${NCCL_VERSION}-1+cuda10.2 \
                        libcudnn7-dev=${CUDNN_VERSION}-1+cuda10.2


#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start final release image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM ubuntu:18.04 as final

COPY --from=base / /

#############################################################################################################################
#####
#####   nvidia-docker v1 and nvidia-container-runtime variables and configuration
#####
#############################################################################################################################

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV LIBRARY_PATH=/usr/local/cuda/lib64/stubs
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_REQUIRE_CUDA="cuda>=10.2 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=439,driver<441"


