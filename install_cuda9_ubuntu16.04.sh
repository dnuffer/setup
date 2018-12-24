#!/bin/bash
set -x
set -e
set -u

if [ $UID != "0" ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub | apt-key add -
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list
echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list
apt-get update

CUDA_PKG_SUFFIX=cuda9.0
CUDA_VERSION=9.0.176

CUDA_PKG_VERSION=9-0=$CUDA_VERSION-1
apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION
ln -sf cuda-9.0 /usr/local/cuda

NCCL_VERSION=2.2.13

apt-get install -y --no-install-recommends \
        cuda-libraries-$CUDA_PKG_VERSION \
        libnccl2=$NCCL_VERSION-1+$CUDA_PKG_SUFFIX
apt-mark hold libnccl2

CUDNN_VERSION=7.2.1.38

apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+$CUDA_PKG_SUFFIX \
            libcudnn7-dev=$CUDNN_VERSION-1+$CUDA_PKG_SUFFIX
apt-mark hold libcudnn7

apt-get install -y --no-install-recommends \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        libnccl-dev=$NCCL_VERSION-1+$CUDA_PKG_SUFFIX \

# this is rather weird, the nvinfer repo is contained in this package
NVINFER_VERSION=4.1.2
apt-get install -y --no-install-recommends \
	nvinfer-runtime-trt-repo-ubuntu1604-4.0.1-ga-cuda9.0

apt-get update
apt-get install -y libnvinfer4=$NVINFER_VERSION-1+$CUDA_PKG_SUFFIX
