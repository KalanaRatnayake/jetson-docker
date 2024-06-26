# jetson-docker

## Docker buildx for ARM64 platform

```bash
docker buildx create --use --driver-opt network=host --name MultiPlatform --platform linux/arm64
```

## Ubuntu Foxy (r32.7.1)

[dustynv/ros:humble-ros-core-l4t-r32.7.1](https://hub.docker.com/layers/dustynv/ros/humble-ros-core-l4t-r32.7.1/images/sha256-833447d4c81735c71cd61587b9cd61275cf7158f44bec074a135e6f3e662187a?context=explore) bases itself on offical [nvcr.io/nvidia/l4t-base:r32.7.1](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base/tags) which is a variant of Ubuntu 18.04. Though dusty's container provides ROS Humble, It is limited by Python 3.6.9. Due to this, being inspired from [Qengineering/Jetson-Nano-Ubuntu-20-image](https://github.com/Qengineering/Jetson-Nano-Ubuntu-20-image) and [This guidelines](https://gist.github.com/gpshead/0c3a9e0a7b3e180d108b6f4aef59bc19), this attempt is to upgrade the kernal of [nvcr.io/nvidia/l4t-base:r32.7.1](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base/tags) to Ubuntu 20.04. 

> Ubuntu 22.04 was also attempted, but later abandoned due to lack of support for gcc-8, g++8 and clang-8 required by CUDA 10.2 in r32.7.1

Get the docker container
```bash
docker pull ghcr.io/kalanaratnayake/l4t-foxy-base:r32.7.1
```

Build the docker container locally
```bash
docker buildx build --load --platform linux/arm64 -f base-images/jetson_nano_foxy.Dockerfile -t l4t-foxy-base:r32.7.1 .
```
<br>