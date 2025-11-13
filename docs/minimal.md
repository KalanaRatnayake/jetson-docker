# Minimal and CUDA images

Lightweight developer-friendly layers that add toolchains and CUDA to the base images.

## Available tags

| Image         | Tag                | Size    | Tested on         | Content highlights |
| :------------ | :----------------- | :-----: | :--------------   | :----------------- |
| jetson-minimal| r32.7.1            | 1.11 GB | Jetson Nano       | jetson-base:r32.7.1 + GCC-8, G++-8, build-essentials |
| l4t-cuda      | 12.2.12-runtime    | 1.41 GB | Jetson AGX Xavier | l4t-base:r35.2.1 + CUDA 12.2 |
| l4t-cuda      | 12.6.11-runtime    | 1.21 GB | Jetson AGX Orin   | l4t-base:r36.2.0 + CUDA 12.6 |

## How to use

```dockerfile
# Minimal tools (r32.7.1)
FROM ghcr.io/kalanaratnayake/jetson-minimal:r32.7.1

# CUDA devel/runtime (r35.2.1)
FROM nvcr.io/nvidia/l4t-cuda:12.2.12-runtime

# CUDA runtime (r36.2.0)
FROM nvcr.io/nvidia/l4t-cuda:12.6.11-runtime
```

## Per-version docs

- jetson-minimal:r32.7.1 — install, test, local build: [minimal/r3271.md](minimal/r3271.md)
- l4t-cuda:12.2.12-runtime — install: [minimal/r3521r.md](minimal/r3521r.md)
- l4t-cuda:12.6.11-runtime — install: [minimal/r3620r.md](minimal/r3620r.md)