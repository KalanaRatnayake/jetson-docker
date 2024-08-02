# Jetson Docker

This repository contains dockerfiles for base images for Jetson Nano and Jetson AGX Orin devices. Following table contains a summary about available images and the Jetson Linux Kernal they are based on.

| Name       | Content                                 | Jetson Nano | Jetson AGX Orin |
| :--------- | :-------------------------------------- | :---------: | :-------------: |
| foxy-base  | Ubuntu 20.04, Python 3.8.10  |  `r32.7.1` / 822MB
| Content    | Content Cell  |

## Docker buildx for ARM64 platform (for AMD64 systems)

Run the following command on a AMD64 computer to setup buildx to build arm64 docker containers.
```bash
docker buildx create --use --driver-opt network=host --name MultiPlatform --platform linux/arm64
```

## Docker container list

<details> 
<summary> <h3> foxy-base </h3> </summary>

This image is an modified [nvcr.io/nvidia/l4t-base:r32.7.1](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base/tags). The image has been modified by upgrading core Ubuntu 18.04 to Ubuntu 20.04. 

[dusty-nv/jetson-containers](https://github.com/dusty-nv/jetson-containers) allows building image for Jetson nano but they are based on offical [nvcr.io/nvidia/l4t-base:r32.7.1](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base/tags) which is based on Ubuntu 18.04 and is limited by Python 3.6.9. 

Due to this, being inspired from [Qengineering/Jetson-Nano-Ubuntu-20-image](https://github.com/Qengineering/Jetson-Nano-Ubuntu-20-image) and based on [gpshead/Dockerfile](https://gist.github.com/gpshead/0c3a9e0a7b3e180d108b6f4aef59bc19), this image provides an Ubuntu 20.04 version of [nvcr.io/nvidia/l4t-base:r32.7.1](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base/tags)

> Ubuntu 22.04 was also attempted, but later abandoned due to lack of support for gcc-8, g++8 and clang-8 required by CUDA 10.2 in r32.7.1

### Pull or Build

Pull the docker container
```bash
docker pull ghcr.io/kalanaratnayake/foxy-base:r32.7.1
```

or

Build the docker container
```bash
docker buildx build --load --platform linux/arm64 -f base-images/foxy.jnano.Dockerfile -t foxy-base:r32.7.1 .
```

### Start

Start the docker container
```bash
docker run --rm -it --runtime nvidia --network host --gpus all -e DISPLAY ghcr.io/kalanaratnayake/foxy-base:r32.7.1 bash
```
<br>

</details>

<details> 
<summary> <h3> Jetson Ubuntu Foxy Minimal Image </h3> </summary>

- Size is about 1.11GB
- Contains,
    * Python 3.8.10
    * GCC-8, G++-8 (for building CUDA 10.2 related applications)
    * build-essential package (g++-9, gcc-9, make, dpkg-dev, libc6-dev)

### Pull or Build

Pull the docker container
```bash
docker pull ghcr.io/kalanaratnayake/foxy-minimal:r32.7.1
```

Build the docker container
```bash
docker buildx build --load --platform linux/arm64 -f test-images/foxy_test.Dockerfile -t foxy-minimal:r32.7.1 .
```

### Start

Start the docker container
```bash
docker run --rm -it --runtime nvidia --network host --gpus all -e DISPLAY ghcr.io/kalanaratnayake/foxy-minimal:r32.7.1 bash
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

<details> 
<summary> <h3> Jetson ROS Humble Core Image </h3> </summary>
  
- Size is about 1.71GB
- Contains,
    * Python 3.8.10
    * build-essential package (g++-9, gcc-9, make, dpkg-dev, libc6-dev)
    * ROS Humble [Core packages](https://www.ros.org/reps/rep-2001.html#id23)
  
### Pull or Build

Pull the docker container
```bash
docker pull ghcr.io/kalanaratnayake/foxy-ros:humble-core-r32.7.1
```

Build the docker container
```bash
docker buildx build --load --platform linux/arm64 -f ros-images/humble_core.Dockerfile -t foxy-ros:humble-core-r32.7.1 .
```

or build with cache locally and push when image compilation can be slow on github actions and exceeds 6rs

```bash
docker buildx build --push \
                    --platform linux/arm64 \
                    --cache-from=type=registry,ref=ghcr.io/kalanaratnayake/foxy-ros:humble-ros-core-buildcache \
                    --cache-to=type=registry,ref=ghcr.io/kalanaratnayake/foxy-ros:humble-ros-core-buildcache,mode=max  \
                    -f ros-images/humble_core.Dockerfile  \
                    -t ghcr.io/kalanaratnayake/foxy-ros:humble-core-r32.7.1 .
```

### Start

Start the docker container

```bash
docker run --rm -it --runtime nvidia --network host --gpus all -e DISPLAY ghcr.io/kalanaratnayake/foxy-ros:humble-core-r32.7.1 bash
```

### Test

Run the following commands inside the docker container to confirm that the container is working properly
```bash
ros2 run demo_nodes_cpp talker
```

Run the following commands on another instance of ros container or another Computer/Jetson device installed with ROS humble to check 
connectivity over host network and discoverability (while the above command is running).
```bash
ros2 run demo_nodes_py listener
```

<br>

</details>

<details> 
<summary> <h3> Jetson ROS Humble Base Image </h3> </summary>

- Size is about 1.76GB
- Contains,
    * Python 3.8.10
    * build-essential package (g++-9, gcc-9, make, dpkg-dev, libc6-dev)
    * ROS Humble [Base packages](https://www.ros.org/reps/rep-2001.html#id24)
  
### Pull or Build

Pull the docker container
```bash
docker pull ghcr.io/kalanaratnayake/foxy-ros:humble-base-r32.7.1
```

Build the docker container
```bash
docker buildx build --load --platform linux/arm64 -f ros-images/humble_base.Dockerfile -t foxy-ros:humble-base-r32.7.1 .
```

or build with cache locally and push when image compilation can be slow on github actions and exceeds 6rs

```bash
docker buildx build --push \
                    --platform linux/arm64 \
                    --cache-from=type=registry,ref=ghcr.io/kalanaratnayake/foxy-ros:humble-ros-base-buildcache \
                    --cache-to=type=registry,ref=ghcr.io/kalanaratnayake/foxy-ros:humble-ros-base-buildcache,mode=max  \
                    -f ros-images/humble_base.Dockerfile  \
                    -t ghcr.io/kalanaratnayake/foxy-ros:humble-base-r32.7.1 .
```

### Start

Start the docker container
```bash
docker run --rm -it --runtime nvidia --network host --gpus all -e DISPLAY ghcr.io/kalanaratnayake/foxy-ros:humble-base-r32.7.1 bash
```

### Test

Run the following commands inside the docker container to confirm that the container is working properly.
```bash
ros2 run demo_nodes_cpp talker
```

Run the following commands on another instance of ros container or another Computer/Jetson device installed with ROS humble to check 
connectivity over host network and discoverability (while the above command is running).
```bash
ros2 run demo_nodes_py listener
```

<br>
</details>

<details> 
<summary> <h3> Jetson Ubuntu Foxy Pytorch 1.13 Image </h3> </summary>
  
- Size is about 1.83GB
- Contains,
    * Python 3.8.10
    * PyTorch 1.13.0
    * TorchVision 0.14.0
  
### Pull or Build

Pull the docker container
```bash
docker pull ghcr.io/kalanaratnayake/foxy-pytorch:1-13-r32.7.1
```

Build the docker container
```bash
docker buildx build --load --platform linux/arm64 -f pytorch-images/foxy_pytorch_1_13.Dockerfile -t foxy-pytorch:1-13-r32.7.1 .
```

### Start

Start the docker container

```bash
docker run --rm -it --runtime nvidia --network host --gpus all -e DISPLAY ghcr.io/kalanaratnayake/foxy-pytorch:1-13-r32.7.1 bash
```

### Test

Run the following commands inside the docker container to confirm that the container is working properly.
```bash
python3 -c "import torch; print(torch.__version__)"
python3 -c "import torchvision; print(torchvision.__version__)"
```

<br>

</details>

<details> 
<summary> <h3> Jetson Ubuntu Foxy Pytorch 1.13 with TensorRT Image </h3> </summary>
  
- Size is about 1.83GB
- Contains,
    * Python 3.8.10
    * PyTorch 1.13.0
    * TorchVision 0.14.0
  
### Pull or Build

Pull the docker container
```bash
docker pull ghcr.io/kalanaratnayake/foxy-pytorch:1-13-tensorrt-j-nano
```

Build the docker container
```bash
docker buildx build --load --platform linux/arm64 -f pytorch-images/foxy_pytorch_1_13.Dockerfile -t foxy-pytorch:1-13-tensorrt-j-nano .
```

### Start

Start the docker container

```bash
docker run --rm -it --runtime nvidia --network host --gpus all -e DISPLAY ghcr.io/kalanaratnayake/foxy-pytorch:1-13-tensorrt-j-nano bash
```

### Test

Run the following commands inside the docker container to confirm that the container is working properly.
```bash
python3 -c "import torch; print(torch.__version__)"
python3 -c "import torchvision; print(torchvision.__version__)"
python3 -c "import tensorrt as trt; print(trt.__version__)"
dpkg -l | grep TensorRT
```

<br>

</details>

<details> 
<summary> <h3> Jetson Ubuntu Foxy Humble Core Pytorch 1.13 Image </h3> </summary>
  
- Size is about 3.05GB
- Contains,
    * Python 3.8
    * PyTorch 1.13.0
    * TorchVision 0.14.0
    * ROS Humble [Core packages](https://www.ros.org/reps/rep-2001.html#id23)
  
### Pull or Build

Pull the docker container
```bash
docker pull ghcr.io/kalanaratnayake/foxy-ros-pytorch:1-13-humble-core-r32.7.1
```

Build the docker container
```bash
docker buildx build --load --platform linux/arm64 -f ros-pytorch-images/humble_core_pytorch_1_13.Dockerfile -t foxy-ros-pytorch:1-13-humble-core-r32.7.1 .
```

### Start

Start the docker container

```bash
docker run --rm -it --runtime nvidia --network host --gpus all -e DISPLAY ghcr.io/kalanaratnayake/foxy-ros-pytorch:1-13-humble-core-r32.7.1 bash
```

### Test

Run the following commands inside the docker container to confirm that the container is working properly.
```bash
python3 -c "import torch; print(torch.__version__)"
python3 -c "import torchvision; print(torchvision.__version__)"
```

Run the following commands inside the docker container to confirm that the container is working properly.
```bash
ros2 run demo_nodes_cpp talker
```

Run the following commands on another instance of ros container or another Computer/Jetson device installed with ROS humble to check 
connectivity over host network and discoverability (while the above command is running).
```bash
ros2 run demo_nodes_py listener
```

<br>

</details>
