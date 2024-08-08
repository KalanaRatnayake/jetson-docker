FROM ghcr.io/kalanaratnayake/jetson-ros:humble-core-r36.3.0 as base

WORKDIR /

######################################################################################
##                           Install dependencies
######################################################################################

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends python3-pip

#####################################################################################
##                           Install PyTorch
#####################################################################################

RUN python3 -m pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

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