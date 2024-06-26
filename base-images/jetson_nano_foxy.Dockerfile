#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image based on https://gist.github.com/gpshead/0c3a9e0a7b3e180d108b6f4aef59bc19
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM nvcr.io/nvidia/l4t-base:r32.7.1 AS base

#######################################################################################
###                        Upgrade from 18.04 to 20.04
#######################################################################################

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends ubuntu-release-upgrader-core 

RUN do-release-upgrade -f DistUpgradeViewNonInteractive

RUN apt-get update && apt-get upgrade -y

RUN apt-get clean

RUN apt-get install -y --no-install-recommends vim

RUN dpkg --configure -a

RUN apt-get remove python2 -y

RUN apt-get autoremove -y

RUN apt-get clean

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

#######################################################################################
###                  Clean the files for size reduction
#######################################################################################

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
RUN apt-get clean

#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start final release image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM scratch as final

COPY --from=base / /


