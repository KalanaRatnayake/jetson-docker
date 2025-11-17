# ROS + PyTorch images

Combined images with ROS 2 Humble Base variant and PyTorch ready to go.

## Available tags

| Image              | Tag                  | Size    | Tested on         | Content highlights |
| :----------------- | :---------------| :-----: | :--------------   | :----------------- |
| jetson-ros-pytorch | humble-r32.7.1  | 3.05 GB | Jetson Nano       | ROS Humble + PyTorch 1.13.0 |
| jetson-ros-pytorch | humble-r35.2.1  | 1.91 GB | Jetson AGX Xavier | ROS Humble + PyTorch 2.1.0 |
| jetson-ros-pytorch | humble-r36.3.0  | 1.91 GB | Jetson AGX Orin   | ROS Humble + PyTorch 2.5.0 |

## How to use

```dockerfile
# Jetson Nano
FROM ghcr.io/kalanaratnayake/jetson-ros-pytorch:1.13-humble-r32.7.1

# Jetson AGX Xavier
FROM ghcr.io/kalanaratnayake/jetson-ros-pytorch:humble-r35.2.1

# Jetson AGX Orin
FROM ghcr.io/kalanaratnayake/jetson-ros-pytorch:humble-r36.3.0
```

## Per-version docs

- humble-r32.7.1 — install, test, local build: [ros-pytorch/humble/r3271.md](ros-pytorch/humble/r3271.md)
- humble-r35.2.1 — install, test, local build: [ros-pytorch/humble/r3521.md](ros-pytorch/humble/r3521.md)
- humble-r36.3.0 — install, test, local build: [ros-pytorch/humble/r3630.md](ros-pytorch/humble/r3630.md)