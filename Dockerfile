FROM kratan/bwvisu-nvidia:centos7
LABEL maintainer="andreas.kratzer@kit.edu"

#Set Cuda Versions
ENV CUDA_VERSION=8.0.61
ENV CUDA_PKG_VERSION=8-0-$CUDA_VERSION-1

#adding nvidia rep key
RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 \
	&& curl -fsSL http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/7fa2af80.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA \ 
	&& echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

COPY cuda.repo /etc/yum.repos.d/cuda.repo

#Set WorkDir to temp
WORKDIR "/tmp"

#Install Cuda and cleanup
RUN yum clean all \
    && yum -y update \
    && yum -y install \
		epel-release \
	        cuda-nvrtc-$CUDA_PKG_VERSION \
        	cuda-nvgraph-$CUDA_PKG_VERSION \
	        cuda-cusolver-$CUDA_PKG_VERSION \
	        cuda-cublas-$CUDA_PKG_VERSION \
	        cuda-cufft-$CUDA_PKG_VERSION \
	        cuda-curand-$CUDA_PKG_VERSION \
	        cuda-cusparse-$CUDA_PKG_VERSION \
	        cuda-npp-$CUDA_PKG_VERSION \
	        cuda-cudart-$CUDA_PKG_VERSION \
    && ln -s cuda-8.0 /usr/local/cuda \
    && echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf \
    && ldconfig \
    && yum clean all \
    && rm -Rf /tmp/* \
    && rm -rf /var/cache/yum/*


