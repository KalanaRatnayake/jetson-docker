# Jetson Docker

This repository contains dockerfiles for base images for Jetson Nano and Jetson AGX Orin devices. Following table contains a summary about available images and the Jetson Linux Kernal they are based on.

| Name       | Content                                 | Jetson Nano | Jetson AGX Orin |
| :--------- | :-------------------------------------- | :---------: | :-------------: |
| jetson-base    | Ubuntu 20.04, Python 3.8.10  |  `r32.7.1` / 822MB | |
| jetson-minimal | Ubuntu 20.04, Python 3.8.10, GCC-8, G++-8, build-essential package  |  `r32.7.1` / 1.11GB | |

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
[Installation and local build instructions for jetson-base:r32.7.1 ](base-images/r3721.md)

<br>

### 2. Jetson Minimal

#### jetson-minimal:r32.7.1 

```docker
FROM ghcr.io/kalanaratnayake/jetson-minimal:r32.7.1
```
[Installation and local build instructions for jetson-minimal:r32.7.1 ](minimal-images/r3721.md)

<br>

### 3. Jetson ROS 


  
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
                    --cache-from=type=registry,ref=ghcr.io/kalanaratnayake/jetson-ros:humble-ros-core-r32.7.1-buildcache \
                    --cache-to=type=registry,ref=ghcr.io/kalanaratnayake/jetson-ros:humble-ros-core-r32.7.1-buildcache,mode=max  \
                    -f ros-images/r3271.humble_core.Dockerfile  \
                    -t ghcr.io/kalanaratnayake/jetson-ros:humble-core-r32.7.1 .
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
                    --cache-from=type=registry,ref=ghcr.io/kalanaratnayake/jetson-ros:humble-ros-base-r32.7.1-buildcache \
                    --cache-to=type=registry,ref=ghcr.io/kalanaratnayake/jetson-ros:humble-ros-base-r32.7.1-buildcache,mode=max  \
                    -f ros-images/r3271.humble_base.Dockerfile  \
                    -t ghcr.io/kalanaratnayake/jetson-ros:humble-base-r32.7.1 .
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
