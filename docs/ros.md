# ROS Humble images

Ready-to-use ROS 2 Humble images for Jetson. Choose between Core and Base variants. Both are Headless versions of ROS2 with minimum packages to function.

- Core: Communication libraries, examples
- Base: Core + Image handling support and ROSBag support.

Use Core package if your system only requires basic control functionality without any image handling. Use base package if your system expects image handling, camera access and extended functionality.

## Available tags

| Image      | Tag                    | Size    | Tested on       | Content highlights |
| :--------- | :--------------------- | :-----: | :-------------- | :----------------- |
| jetson-ros | humble-core-r32.7.1    | 1.71 GB | Jetson Nano     | jetson-base:r32.7.1 + ROS Humble Core |
| jetson-ros | humble-base-r32.7.1    | 1.76 GB | Jetson Nano     | jetson-base:r32.7.1 + ROS Humble Base |
| jetson-ros | humble-core-r35.2.1    | 1.40 GB | Jetson AGX Xavier | l4t-base:r35.2.1 + ROS Humble Core |
| jetson-ros | humble-base-r35.2.1    | 1.45 GB | Jetson AGX Xavier | l4t-base:r35.2.1 + ROS Humble Base |
| jetson-ros | humble-core-r36.3.0    | 1.40 GB | Jetson AGX Orin | l4t-base:r36.2.0 + ROS Humble Core |
| jetson-ros | humble-base-r36.3.0    | 1.45 GB | Jetson AGX Orin | l4t-base:r36.2.0 + ROS Humble Base |

## How to use

```dockerfile
# ROS Humble (r32.7.1)
FROM ghcr.io/kalanaratnayake/jetson-ros:humble-core-r32.7.1
FROM ghcr.io/kalanaratnayake/jetson-ros:humble-base-r32.7.1

# ROS Humble (r35.2.1)
FROM ghcr.io/kalanaratnayake/jetson-ros:humble-core-r35.2.1
FROM ghcr.io/kalanaratnayake/jetson-ros:humble-base-r35.2.1

# ROS Humble (r36.3.0)
FROM ghcr.io/kalanaratnayake/jetson-ros:humble-core-r36.3.0
FROM ghcr.io/kalanaratnayake/jetson-ros:humble-base-r36.3.0
```

## Per-version docs

- humble-core-r32.7.1 — install, test, local build: [ros/humble/r3271.core.md](ros/humble/r3271.core.md)
- humble-base-r32.7.1 — install, test, local build: [ros/humble/r3271.base.md](ros/humble/r3271.base.md)
- humble-core-r35.2.1 — install, test, local build: [ros/humble/r3521.core.md](ros/humble/r3521.core.md)
- humble-base-r35.2.1 — install, test, local build: [ros/humble/r3521.base.md](ros/humble/r3521.base.md)
- humble-core-r36.3.0 — install, test, local build: [ros/humble/r3630.core.md](ros/humble/r3630.core.md)
- humble-base-r36.3.0 — install, test, local build: [ros/humble/r3630.base.md](ros/humble/r3630.base.md)

> Tip: These images include an entrypoint for ROS. See [ros/ros_entrypoint.sh](../ros/ros_entrypoint.sh).
