#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM ghcr.io/kalanaratnayake/foxy-base:r32.7.1 AS base

LABEL org.opencontainers.image.description="Jetson ROS Humble Base"

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
                                            pytest-cov \
                                            opencv-python

#############################################################################################################################
#####
#####   Install ROS2 humble ros base
#####
#############################################################################################################################

ARG ROS_VERSION=humble
ARG ROS_PACKAGE=ros_base

RUN add-apt-repository universe

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
 http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ros-dev-tools  \
                                                                              python3-rosinstall-generator 

RUN python3 -m pip install --no-cache-dir   "pytest>=5.3" \
                                            pytest-repeat \
                                            pytest-rerunfailures

ENV ROS_DISTRO=${ROS_VERSION}
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}
ENV ROS_PYTHON_VERSION=3

WORKDIR ${ROS_ROOT}/src

RUN rosinstall_generator --deps --rosdistro ${ROS_DISTRO} ${ROS_PACKAGE} \                                                          
                                                            demo_nodes_cpp \
                                                            demo_nodes_py \
                                                            example_interfaces \
                                                            camera_calibration_parsers \
                                                            camera_info_manager \
                                                            cv_bridge \
                                                            v4l2_camera \
                                                            vision_opencv \
                                                            vision_msgs \
                                                            image_geometry \
                                                            image_pipeline \
                                                            image_transport \
                                                            compressed_image_transport \
                                                            compressed_depth_image_transport \
                                                            cyclonedds \
                                                            rmw_cyclonedds \
                                                            rosbag2_storage_mcap \
                                                        > ros2.${ROS_DISTRO}.${ROS_PACKAGE}.rosinstall

RUN vcs import ${ROS_ROOT}/src < ros2.${ROS_DISTRO}.${ROS_PACKAGE}.rosinstall

WORKDIR ${ROS_ROOT}

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

# remove ros source and build files.

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

ARG ROS_VERSION=humble

ENV ROS_DISTRO=${ROS_VERSION}

ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}

WORKDIR /

ENTRYPOINT ["/ros_entrypoint.sh"]
