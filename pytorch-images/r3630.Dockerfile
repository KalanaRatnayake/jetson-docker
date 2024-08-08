#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM nvcr.io/nvidia/l4t-cuda:12.2.12-runtime AS base

WORKDIR /

######################################################################################
##                           Install dependencies
######################################################################################

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends python3-pip \
                                               libopenblas-dev

RUN python3 -m pip install --no-cache-dir numpy

#####################################################################################
##                           Install PyTorch 2.3
#####################################################################################

RUN wget -O torch-2.3.0-cp310-cp310-linux_aarch64.whl https://nvidia.box.com/shared/static/mp164asf3sceb570wvjsrezk1p4ftj8t.whl

RUN python3 -m pip install --no-cache-dir torch-2.3.0-cp310-cp310-linux_aarch64.whl

RUN rm torch-2.3.0-cp310-cp310-linux_aarch64.whl

#####################################################################################
##                           Install Torch Vision 0.18
#####################################################################################

RUN wget -O torchvision-0.18.0a0+6043bc2-cp310-cp310-linux_aarch64.whl https://nvidia.box.com/shared/static/xpr06qe6ql3l6rj22cu3c45tz1wzi36p.whl

RUN python3 -m pip install --no-cache-dir torchvision-0.18.0a0+6043bc2-cp310-cp310-linux_aarch64.whl

RUN rm torchvision-0.18.0a0+6043bc2-cp310-cp310-linux_aarch64.whl

#####################################################################################
##                           Install Torch Audio 2.3
#####################################################################################

RUN wget -O torchaudio-2.3.0+952ea74-cp310-cp310-linux_aarch64.whl https://nvidia.box.com/shared/static/9agsjfee0my4sxckdpuk9x9gt8agvjje.whl

RUN python3 -m pip install --no-cache-dir torchaudio-2.3.0+952ea74-cp310-cp310-linux_aarch64.whl

RUN rm torchaudio-2.3.0+952ea74-cp310-cp310-linux_aarch64.whl

#####################################################################################
##
##   Remove dev packages to reduce size
##
#####################################################################################

RUN apt-get update -y

RUN apt-get autoremove -y

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