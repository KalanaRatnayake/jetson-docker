#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start foxy-ros image and use precompiled wheels provided by QEngineering team available 
#----   at https://qengineering.eu/install-pytorch-on-jetson-nano.html
#----
#---------------------------------------------------------------------------------------------------------------------------


FROM ghcr.io/kalanaratnayake/foxy-ros:humble-core-r32.7.1 as base

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

RUN python3 -m pip install --no-cache-dir   future \
                                            wheel \
                                            mock \
                                            pillow \
                                            testresources \
                                            setuptools==58.3.0 \
                                            Cython \
                                            gdown \
                                            protobuf

RUN python3 -m pip install --no-cache-dir typing-extensions --upgrade

#####################################################################################
##                           Install PyTorch 1.13.0
#####################################################################################

RUN gdown https://drive.google.com/uc?id=1e9FDGt2zGS5C5Pms7wzHYRb0HuupngK1

RUN python3 -m pip install --no-cache-dir torch-1.13.0a0+git7c98e70-cp38-cp38-linux_aarch64.whl

RUN rm torch-1.13.0a0+git7c98e70-cp38-cp38-linux_aarch64.whl



#####################################################################################
##                           Install TorchVision 0.14.0
#####################################################################################

RUN gdown https://drive.google.com/uc?id=19UbYsKHhKnyeJ12VPUwcSvoxJaX7jQZ2

RUN python3 -m pip install --no-cache-dir torchvision-0.14.0a0+5ce4506-cp38-cp38-linux_aarch64.whl

RUN rm torchvision-0.14.0a0+5ce4506-cp38-cp38-linux_aarch64.whl


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

FROM scratch AS final

COPY --from=base / /

#############################################################################################################################
#####
#####  ROS Humble environment variables and configuration and set the default DDS middleware to cyclonedds
#####  https://github.com/ros2/rclcpp/issues/1335
#####
#############################################################################################################################

ARG ROS_VERSION=humble

ENV ROS_DISTRO=${ROS_VERSION}

ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}

ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

ENV OPENBLAS_CORETYPE=ARMV8

WORKDIR /

ENTRYPOINT ["/ros_entrypoint.sh"]