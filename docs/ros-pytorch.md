# ROS + PyTorch images

Combined images with ROS 2 Humble and PyTorch ready to go.

## Available tags

| Image              | Tag                  | Size    | Tested on         | Content highlights |
| :----------------- | :--------------------| :-----: | :--------------   | :----------------- |
| jetson-ros-pytorch | humble-core-r32.7.1  | 3.05 GB | Jetson Nano       | ROS Humble Core + PyTorch 1.13.0 |
| jetson-ros-pytorch | humble-core-r35.2.1  | 1.91 GB | Jetson AGX Xavier | ROS Humble Core + PyTorch 2.1.0 |
| jetson-ros-pytorch | humble-core-r36.3.0  | 1.91 GB | Jetson AGX Orin   | ROS Humble Core + PyTorch 2.5.0 |

## How to use

```dockerfile
# Jetson Nano
FROM ghcr.io/kalanaratnayake/jetson-ros-pytorch:1.13-humble-core-r32.7.1

# Jetson AGX Xavier
FROM ghcr.io/kalanaratnayake/jetson-ros-pytorch:humble-core-r35.2.1

# Jetson AGX Orin
FROM ghcr.io/kalanaratnayake/jetson-ros-pytorch:humble-core-r36.3.0
```

## Per-version docs

- humble-core-r32.7.1 — install, test, local build: [ros-pytorch/humble/r3271.core_pytorch.md](ros-pytorch/humble/r3271.core_pytorch.md)
- humble-core-r35.2.1 — install, test, local build: [ros-pytorch/humble/r3521.core_pytorch.md](ros-pytorch/humble/r3521.core_pytorch.md)
- humble-core-r36.3.0 — install, test, local build: [ros-pytorch/humble/r3630.core_pytorch.md](ros-pytorch/humble/r3630.core_pytorch.md)