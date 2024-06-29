#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image based on https://gist.github.com/gpshead/0c3a9e0a7b3e180d108b6f4aef59bc19
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM ghcr.io/kalanaratnayake/foxy-base:r32.7.1 AS base

#######################################################################################
###                  Install gcc-8, g++-8, clang8 and python3.8
#######################################################################################

RUN apt-get update -y

RUN apt-get install -y --no-install-recommends gcc-8 \
                                               g++-8 \
                                               python3 \
                                               build-essential \
                                               software-properties-common \
                                               cmake

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
RUN apt-get clean

#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start final release image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM scratch as final

LABEL org.opencontainers.image.description="Jetson Ubuntu Foxy Minimal Image"

COPY --from=base / /
    
ENV PATH=${PATH}:/usr/local/cuda/bin
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64