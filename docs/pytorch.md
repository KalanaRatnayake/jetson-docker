# PyTorch images

Prebuilt PyTorch stacks for Jetson based on the matching L4T/Ubuntu release.

## Available tags

| Image          | Tag         | Size    | Tested on         | Content highlights |
| :------------- | :---------- | :-----: | :--------------   | :----------------- |
| jetson-pytorch | r32.7.1     | 1.83 GB | Jetson Nano       | jetson-base:r32.7.1 + PyTorch 1.13.0, TorchVision 0.14.0 |
| jetson-pytorch | r35.2.1     | 1.26 GB | Jetson AGX Xavier | l4t-base:r35.2.1 + PyTorch 2.1.0, TorchVision 0.16.0, TorchAudio 2.1.0 |
| jetson-pytorch | r36.3.0     | 1.26 GB | Jetson AGX Orin   | l4t-base:r36.2.0 + PyTorch 2.5.0, TorchVision 0.20.0, TorchAudio 2.5.0 |

## How to use

```dockerfile
# Jetson Nano (PyTorch 1.13)
FROM ghcr.io/kalanaratnayake/jetson-pytorch:1.13-r32.7.1

# Jetson AGX Xavier (PyTorch 2.1)
FROM ghcr.io/kalanaratnayake/jetson-pytorch:r35.2.1

# Jetson AGX Orin (PyTorch 2.5)
FROM ghcr.io/kalanaratnayake/jetson-pytorch:r36.3.0
```

## Per-version docs

- r32.7.1 — install, test, local build: [pytorch/r3271.md](pytorch/r3271.md)
- r35.2.1 — install, test, local build: [pytorch/r3521.md](pytorch/r3521.md)
- r36.3.0 — install, test, local build: [pytorch/r3630.md](pytorch/r3630.md)
