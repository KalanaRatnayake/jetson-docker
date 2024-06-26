# Jetson Nano Docker

This repository contains docker containers that are built on top of an modified [nvcr.io/nvidia/l4t-base:r32.7.1](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base/tags) container. The container has been modified by upgrading core Ubuntu 18.04 to Ubuntu 20.04. 

[dusty-nv/jetson-containers](https://github.com/dusty-nv/jetson-containers) allows building containers for Jetson nano but they are based on offical [nvcr.io/nvidia/l4t-base:r32.7.1](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base/tags) which is based on Ubuntu 18.04 and is limited by Python 3.6.9. 

Due to this, being inspired from [Qengineering/Jetson-Nano-Ubuntu-20-image](https://github.com/Qengineering/Jetson-Nano-Ubuntu-20-image) and based on [gpshead/Dockerfile](https://gist.github.com/gpshead/0c3a9e0a7b3e180d108b6f4aef59bc19), this container provides an Ubuntu 20.04 version of [nvcr.io/nvidia/l4t-base:r32.7.1](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base/tags)

> Ubuntu 22.04 was also attempted, but later abandoned due to lack of support for gcc-8, g++8 and clang-8 required by CUDA 10.2 in r32.7.1

## Docker buildx for ARM64 platform (for AMD64 systems)

Run the following command on a AMD64 computer to setup buildx to build arm64 docker containers.
```bash
docker buildx create --use --driver-opt network=host --name MultiPlatform --platform linux/arm64
```

## Base Containers (modified r32.7.1)

<details> 

<summary> <b> Ubuntu Foxy (Size 822 MB) </b> </summary>

### Pull or Build

Pull the docker container
```bash
docker pull ghcr.io/kalanaratnayake/l4t-foxy-base:r32.7.1
```

Build the docker container
```bash
docker buildx build --load --platform linux/arm64 -f base-images/foxy.Dockerfile -t l4t-foxy-base:r32.7.1 .
```

### Start

Start the docker container
```bash
docker run --rm -it --runtime nvidia --network host --gpus all -e DISPLAY ghcr.io/kalanaratnayake/l4t-foxy-base:r32.7.1 bash
```
<br>

</details>

<details> 
<summary> <b> Ubuntu Foxy Test Image with gcc8, g++8 and python 3.8 (Size 1.11 GB) </b> </summary>

### Pull or Build

Pull the docker container
```bash
docker pull ghcr.io/kalanaratnayake/l4t-foxy-base-test:r32.7.1
```

Build the docker container
```bash
docker buildx build --load --platform linux/arm64 -f test-images/foxy_test.Dockerfile -t l4t-foxy-base-test:r32.7.1 .
```

### Start

Start the docker container
```bash
docker run --rm -it --runtime nvidia --network host --gpus all -e DISPLAY ghcr.io/kalanaratnayake/l4t-foxy-base-test:r32.7.1 bash
```

### Test

Run the following commands inside the docker container to test the nvcc and other jetson nano specific functionality
```bash
/usr/local/cuda-10.2/bin/cuda-install-samples-10.2.sh .
cd /NVIDIA_CUDA-10.2_Samples/1_Utilities/deviceQuery
make clean
make HOST_COMPILER=/usr/bin/g++-8
./deviceQuery
```
<br>

</details>