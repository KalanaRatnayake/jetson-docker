#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image based on https://gist.github.com/gpshead/0c3a9e0a7b3e180d108b6f4aef59bc19
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM ghcr.io/kalanaratnayake/l4t-foxy-base:r32.7.1 AS base

#######################################################################################
###                  Install gcc-8, g++-8, clang8 and python3.8
#######################################################################################

RUN apt-get update -y

RUN apt-get install -y --no-install-recommends gcc-8 \
                                               g++-8 \
                                               clang-8 \
                                               python3 \
                                               build-essential \
                                               software-properties-common \
                                               cmake

RUN /usr/local/cuda-10.2/bin/cuda-install-samples-10.2.sh .
                                               
WORKDIR /NVIDIA_CUDA-10.2_Samples/1_Utilities/deviceQuery
                                               
CMD ["make clean && make HOST_COMPILER=/usr/bin/g++-8 && ./deviceQuery"]


