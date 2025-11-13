# Base images

Curated base layers for NVIDIA Jetson devices. Use these as clean starting points for your own images.

- Supported devices: Jetson Nano (r32.7.x) and Jetson AGX Orin (r36.x)
- OS/ABI: Ubuntu 20.04 for r32.7.x, Ubuntu 22.04 for r36.x

## Available tags

| Image       | Tag        | Size    | Tested on           | Content highlights |
| :---------- | :--------- | :-----: | :------------------ | :----------------- |
| jetson-base | r32.7.1    | 822 MB  | Jetson Nano         | Ubuntu 20.04, Python 3.8.10, CUDA 10.2 |
| l4t-base    | r35.2.1    | 750 MB  | Jetson AGX Xavier   | Ubuntu 20.04, Python 3.8.10 |
| l4t-base    | r36.2.0    | 750 MB  | Jetson AGX Orin     | Ubuntu 22.04, Python 3.10.12 |

## How to use

Reference the image directly in your Dockerfile:

```dockerfile
# Jetson Nano (r32.7.1)
FROM ghcr.io/kalanaratnayake/jetson-base:r32.7.1

# Jetson AGX Xavier (r35.2.1)
FROM nvcr.io/nvidia/l4t-base:r35.2.1

# Jetson AGX Orin (r36.2.0)
FROM nvcr.io/nvidia/l4t-base:r36.2.0
```

## Per-version docs

- jetson-base:r32.7.1 — install, test, local build: [base/r3271.md](base/r3271.md)
- l4t-base:r35.2.1 — install, test: [base/r3521.md](base/r3521.md)
- l4t-base:r36.2.0 — install, test: [base/r3620.md](base/r3620.md)

> Notes
> - r32.7.x targets Ubuntu 20.04. r36.x targets Ubuntu 22.04.
> - “l4t-*” images are NVIDIA official. “jetson-*” are custom images in this repo.
