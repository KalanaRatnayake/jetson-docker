# Jetson Docker

This repository contains dockerfiles for base images for Jetson Nano and Jetson AGX Orin devices. Following table contains a summary about available images and the main packages they contain and the device in which the image has been tested on. 

| Image              |  Tag                     | Size    | Content                                                        | Jetson Nano | Jetson AGX Orin |
| :----              | :-----                   | :----:  | :--------------------------------------                        | :---------: | :-------------: |
| jetson-base        | r32.7.1                  |  822 MB | Ubuntu 20.04, Python 3.8.10                                    | <ul><li> - [x] </li></ul> | |
| jetson-minimal     | r32.7.1                  | 1.11 GB | `jetson-base:r32.7.1` + GCC-8, G++-8, build-essentials    | <ul><li> - [x] </li></ul> | |
| jetson-ros         | humble-core-r32.7.1      | 1.71 GB | `jetson-base:r32.7.1` + build-essentials, [ROS Humble Core](https://www.ros.org/reps/rep-2001.html#id23)    | <ul><li> - [x] </li></ul> | |
| jetson-ros         | humble-base-r32.7.1      | 1.76 GB | `jetson-base:r32.7.1` +  build-essentials, [ROS Humble Base](https://www.ros.org/reps/rep-2001.html#id24)    | <ul><li> - [x] </li></ul> | |
| jetson-pytorch     | 1.13-r32.7.1             | 1.83 GB |`jetson-base:r32.7.1` +  PyTorch 1.13.0, TorchVision 0.14.0       | <ul><li> - [x] </li></ul> | |
| jetson-ros-pytorch | 1.13-humble-core-r32.7.1 | 3.05 GB | `jetson-ros:humble-core-r32.7.1` + PyTorch 1.13.0, TorchVision 0.14.0    | <ul><li> - [x] </li></ul> | |


> build essential package for ubuntu 20.04 includes g++-9, gcc-9, make, dpkg-dev, libc6-dev \
> build essential package for ubuntu 22.04 includes g++-11, gcc-11, make, dpkg-dev, libc6-dev

## Docker buildx for ARM64 platform (for AMD64 systems)

Run the following command on a AMD64 computer to setup buildx to build arm64 docker containers.
```bash
docker buildx create --use --driver-opt network=host --name MultiPlatform --platform linux/arm64
```

## Docker container list

### 1. Jetson Base

#### jetson-base:r32.7.1 

```docker
FROM ghcr.io/kalanaratnayake/jetson-base:r32.7.1
```
[Installation and local build instructions for jetson-base:r32.7.1 ](base-images/r3271.md)

<br>

### 2. Jetson Minimal

#### jetson-minimal:r32.7.1 

```docker
FROM ghcr.io/kalanaratnayake/jetson-minimal:r32.7.1
```
[Installation, Testing and local build instructions for jetson-minimal:r32.7.1](minimal-images/r3271.md)

<br>

### 3. Jetson ROS 

#### jetson-ros:humble-core-r32.7.1

```docker
FROM ghcr.io/kalanaratnayake/jetson-ros:humble-core-r32.7.1
```
[Installation, Testing and local build instructions for jetson-ros:humble-core-r32.7.1](ros-images/r3271.humble_core.md)


#### jetson-ros:humble-base-r32.7.1

```docker
FROM ghcr.io/kalanaratnayake/jetson-ros:humble-base-r32.7.1
```
[Installation, Testing and local build instructions for jetson-ros:humble-base-r32.7.1](ros-images/r3271.humble_base.md)

<br>

### 4. Jetson Pytorch 

#### jetson-pytorch:1.13-r32.7.1

```docker
FROM ghcr.io/kalanaratnayake/jetson-pytorch:1.13-r32.7.1
```
[Installation, Testing and local build instructions for jetson-pytorch:1.13-r32.7.1](pytorch-images/r3271.113.md)

<br>

### 4. Jetson ROS Pytorch 

#### jetson-ros-pytorch:1.13-humble-core-r32.7.1

```docker
FROM ghcr.io/kalanaratnayake/jetson-ros-pytorch:1.13-humble-core-r32.7.1
```
[Installation, Testing and local build instructions for jetson-ros-pytorch:1.13-humble-core-r32.7.1](ros-pytorch-images/r3271.humblecore_pytorch113.md)

<br>
