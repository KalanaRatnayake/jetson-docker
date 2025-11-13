# Jetson Docker

This repository contains Dockerfiles for base and application images for Jetson Nano and Jetson AGX Orin devices. Below is a quick summary, with full category pages for details and per-version instructions.

## Documentation

- Base images: [docs/base.md](docs/base.md)
- Minimal and CUDA images: [docs/minimal.md](docs/minimal.md)
- ROS Humble images: [docs/ros.md](docs/ros.md)
- PyTorch images: [docs/pytorch.md](docs/pytorch.md)
- ROS + PyTorch images: [docs/ros-pytorch.md](docs/ros-pytorch.md)

Jump into a page to see supported tags, sizes, how to use, and links to detailed build/test guides. “jetson-*” images are custom images; “l4t-*” images are NVIDIA official.

## Docker buildx for ARM64 platform on AMD64 systems

Run the following command on a AMD64 computer to setup buildx to build arm64 docker containers.
```bash
docker buildx create --use --driver-opt network=host --name MultiPlatform --platform linux/arm64
```
## Docker buildx for ARM64 platform on Jetson devices

Run the following command on a Jetson device to setup buildx to build arm64 docker containers.
```bash
docker buildx create --use --driver=docker-container --name=container --buildkitd-flags '--debug' --bootstrap
```

## Repository layout

- base/ — base Dockerfiles and assets
- minimal/ — minimal and CUDA Dockerfiles
- ros/ — ROS 2 Humble Dockerfiles and entrypoint
- pytorch/ — PyTorch Dockerfiles
- ros-pytorch/ — combined ROS + PyTorch Dockerfiles

## CI orchestrators

Use the orchestrator workflows to build images in sequence on native ARM runners, without juggling dependencies manually:

- r32.7.1: Actions → “Orchestrate r32.7.1 pipeline”
- r35.2.1: Actions → “Orchestrate r35.2.1 pipeline”
- r36.3.0: Actions → “Orchestrate r36.3.0 pipeline”

What they do
- Dispatch each workflow (Base, Minimal, ROS, PyTorch, ROS+PyTorch) in the right order and wait for completion between steps.
- Child workflows also define automatic triggers, but builds triggered by workflow completion are skipped to avoid duplicates. Orchestrators take priority.

Tips
- You can still run any individual workflow via its “Run workflow” button or on push/PR.
- All CI runs use GitHub’s ubuntu-24.04-arm runners (no QEMU emulation).
