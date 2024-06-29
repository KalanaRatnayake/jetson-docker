#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image from humble ros core image to reduce build time as this ros base is an extention of ros core
#----   So most of the dependencies have been installed already.
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM ghcr.io/kalanaratnayake/foxy-ros:humble-ros-core-r32.7.1 AS base

#############################################################################################################################
#####
#####   Install core packages and python3
#####
#############################################################################################################################

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends cmake \
                                               build-essential \
                                               wget \
                                               unzip \                                              
                                               software-properties-common \
                                               curl \
                                               git \
                                               gnupg2 \
                                               ca-certificates \
                                               pkg-config \
                                               lsb-release \
                                               python3-dev \
                                               libpython3-dev \
                                               ros-dev-tools  \
                                               python3-rosinstall-generator 

ENV LANG=en_US.UTF-8
ENV PYTHONIOENCODING=utf-8

#############################################################################################################################
#####
#####   Install ROS2 humble ros base
#####
#############################################################################################################################

ARG ROS_VERSION=humble
ARG ROS_PACKAGE=ros_base

ENV ROS_DISTRO=${ROS_VERSION}
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}
ENV ROS_PYTHON_VERSION=3

## remove packages built for ros_core
RUN rm -rf ${ROS_ROOT}/install

WORKDIR ${ROS_ROOT}/src

RUN rosinstall_generator --deps --rosdistro ${ROS_DISTRO} ${ROS_PACKAGE} \
                                                            cyclonedds \
                                                            rmw_cyclonedds \
                                                        > ros2.${ROS_DISTRO}.${ROS_PACKAGE}.rosinstall

RUN vcs import ${ROS_ROOT}/src < ros2.${ROS_DISTRO}.${ROS_PACKAGE}.rosinstall

WORKDIR ${ROS_ROOT}

RUN rm /etc/ros/rosdep/sources.list.d/20-default.list

RUN rosdep init && rosdep update

RUN rosdep install -y \
	               --ignore-src \
	               --from-paths src \
	               --rosdistro ${ROS_DISTRO} \
                   --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"

RUN colcon build \
            --merge-install \
            --cmake-args -DCMAKE_BUILD_TYPE=Release 

WORKDIR /

# remove ros source and build files
RUN rm -rf ${ROS_ROOT}/src
RUN rm -rf ${ROS_ROOT}/log
RUN rm -rf ${ROS_ROOT}/build

RUN apt-get clean

#############################################################################################################################
#####
#####   Remove dev packages to reduce size
#####
#############################################################################################################################

RUN apt-get update -y

RUN apt-get purge --yes cmake \
                        build-essential \
                        wget \
                        unzip \
                        software-properties-common \
                        curl \
                        git \
                        gnupg2 \
                        ca-certificates \
                        pkg-config \
                        lsb-release \
                        python3-dev \
                        libpython3-dev \
                        ros-dev-tools  \
                        python3-rosinstall-generator 

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
RUN apt-get clean

#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start final release image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM ghcr.io/kalanaratnayake/foxy-ros:humble-ros-core-r32.7.1 AS final

COPY --from=base / /

COPY ros-images/ros_entrypoint.sh /ros_entrypoint.sh

RUN chmod +x /ros_entrypoint.sh

#############################################################################################################################
#####
#####  ROS Humble environment variables and configuration
#####
#############################################################################################################################

LABEL org.opencontainers.image.description="Jetson ROS Humble Base Image"

# Set the default DDS middleware to cyclonedds
# https://github.com/ros2/rclcpp/issues/1335

ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

ENV OPENBLAS_CORETYPE=ARMV8

ARG ROS_VERSION=humble

ENV ROS_DISTRO=${ROS_VERSION}

ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}

WORKDIR /

# Set entry point
ENTRYPOINT ["/ros_entrypoint.sh"]