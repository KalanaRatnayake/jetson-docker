#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM nvcr.io/nvidia/l4t-base:r36.2.0 AS base

ENV ROS_VERSION=humble

#############################################################################################################################
#####
#####   Install core packages, python3 and opencv
#####
#############################################################################################################################

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends cmake \
                                               build-essential \
                                               wget \
                                               unzip \
                                               locales \                                               
                                               software-properties-common \
                                               curl \
                                               git \
                                               gnupg2 \
                                               ca-certificates \
                                               pkg-config \
                                               lsb-release\
                                               python3 \
                                               python3-dev \
                                               python3-distutils \
                                               python3-pip \
                                               python3-venv \
                                               libpython3-dev \
                                               libboost-python-dev                                        
                                               
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV PYTHONIOENCODING=utf-8

RUN python3 -m pip install --no-cache-dir   numpy \
                                            opencv-python

#############################################################################################################################
#####
#####   Install ROS2 humble ros base
#####
#############################################################################################################################

RUN add-apt-repository universe

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
 http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ros-${ROS_VERSION}-ros-base \
                                                                              ros-${ROS_VERSION}-rmw-cyclonedds-cpp \
                                                                              ros-${ROS_VERSION}-demo-nodes-cpp \
                                                                              ros-${ROS_VERSION}-demo-nodes-py \
                                                                              ros-dev-tools

RUN rosdep init && rosdep update

WORKDIR /

RUN apt-get clean

#############################################################################################################################
#####
#####   Remove dev packages to reduce size
#####
#############################################################################################################################

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

COPY ros-images/ros_entrypoint.sh /ros_entrypoint.sh

RUN chmod +x /ros_entrypoint.sh

#############################################################################################################################
#####
#####  ROS Humble environment variables and configuration and set the default DDS middleware to cyclonedds
#####  https://github.com/ros2/rclcpp/issues/1335
#####
#############################################################################################################################

ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

ENV OPENBLAS_CORETYPE=ARMV8

ENV ROS_PYTHON_VERSION=3

ENV ROS_DISTRO=humble

ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}

WORKDIR /

ENTRYPOINT ["/ros_entrypoint.sh"]
