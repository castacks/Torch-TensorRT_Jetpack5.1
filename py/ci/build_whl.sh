#!/bin/bash

# Example usage: docker run -it -v$(pwd)/..:/workspace/TRTorch build_trtorch_wheel /bin/bash /workspace/TRTorch/py/build_whl.sh

cd /workspace/project/py

export CXX=g++
export CUDA_HOME=/usr/local/cuda-11.7
PROJECT_DIR=/workspace/project

cp -r $CUDA_HOME /usr/local/cuda

build_py37() {
    /opt/python/cp37-cp37m/bin/python -m pip install --upgrade pip
    /opt/python/cp37-cp37m/bin/python -m pip install -r requirements.txt
    /opt/python/cp37-cp37m/bin/python setup.py bdist_wheel --release --ci
    #LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/python/cp37-cp37m/lib/python3.7/site-packages/torch/lib:/opt/python/cp37-cp37m/lib/python3.7/site-packages/tensorrt/:/usr/local/cuda-11.7/lib64:/usr/local/cuda-11.7/lib64/stubs /opt/python/cp37-cp37m/bin/python -m auditwheel repair --plat manylinux_2_17_x86_64 dist/torch_tensorrt-*-cp37-cp37m-linux_x86_64.whl
}

build_py38() {
    /opt/python/cp38-cp38/bin/python -m pip install --upgrade pip
    /opt/python/cp38-cp38/bin/python -m pip install -r requirements.txt
    /opt/python/cp38-cp38/bin/python setup.py bdist_wheel --release --ci
    #LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/python/cp38-cp38/lib/python3.8/site-packages/torch/lib:/opt/python/cp38-cp38/lib/python3.8/site-packages/tensorrt/:/usr/local/cuda-11.7/lib64:/usr/local/cuda-11.7/lib64/stubs /opt/python/cp38-cp38/bin/python -m auditwheel repair --plat manylinux_2_17_x86_64 dist/torch_tensorrt-*-cp38-cp38-linux_x86_64.whl
}

build_py39() {
    /opt/python/cp39-cp39/bin/python -m pip install --upgrade pip
    /opt/python/cp39-cp39/bin/python -m pip install -r requirements.txt
    /opt/python/cp39-cp39/bin/python setup.py bdist_wheel --release --ci
    #LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/python/cp39-cp39/lib/python3.8/site-packages/torch/lib:/opt/python/cp39-cp39/lib/python3.9/site-packages/tensorrt/:/usr/local/cuda-11.7/lib64:/usr/local/cuda-11.7/lib64/stubs /opt/python/cp39-cp39/bin/python -m auditwheel repair --plat manylinux_2_17_x86_64 dist/torch_tensorrt-*-cp39-cp39-linux_x86_64.whl
}

build_py310() {
    /opt/python/cp310-cp310/bin/python -m pip install --upgrade pip
    /opt/python/cp310-cp310/bin/python -m pip install -r requirements.txt
    /opt/python/cp310-cp310/bin/python setup.py bdist_wheel --release --ci
    #LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/python/cp310-cp310/lib/python3.8/site-packages/torch/lib:/opt/python/cp310-cp310/lib/python3.8/site-packages/tensorrt/:/usr/local/cuda-11.7/lib64:/usr/local/cuda-11.7/lib64/stubs /opt/python/cp38-cp38/bin/python -m auditwheel repair --plat manylinux_2_17_x86_64 dist/torch_tensorrt-*-cp310-cp310-linux_x86_64.whl
}

#build_py311() {
#    /opt/python/cp311-cp311/bin/python -m pip install -r requirements.txt
#    /opt/python/cp311-cp311/bin/python setup.py bdist_wheel --release --ci
#    #auditwheel repair --plat manylinux_2_17_x86_64
#}

build_libtorchtrt() {
    bazel clean
    bazel build //:libtorchtrt --platforms //toolchains:ci_rhel_x86_64_linux -c opt --noshow_progress
    CUDA_VERSION=$(cd ${PROJECT_DIR}/py/torch_tensorrt && python3 -c "from _version import __cuda_version__;print(__cuda_version__)")
    TORCHTRT_VERSION=$(cd ${PROJECT_DIR}/py/torch_tensorrt && python3 -c "from _version import __version__;print(__version__)")
    TRT_VERSION=$(cd ${PROJECT_DIR}/py/torch_tensorrt && python3 -c "from _version import __tensorrt_version__;print(__tensorrt_version__)")
    CUDNN_VERSION=$(cd ${PROJECT_DIR}/py/torch_tensorrt && python3 -c "from _version import __cudnn_version__;print(__cudnn_version__)")
    TORCH_VERSION=$(/opt/python/cp310-cp310/bin/python -c "from torch import __version__;print(__version__.split('+')[0])")
    cp ${PROJECT_DIR}/bazel-bin/libtorchtrt.tar.gz ${PROJECT_DIR}/py/dist/libtorchtrt-${TORCHTRT_VERSION}-cudnn${CUDNN_VERSION}-tensorrt${TRT_VERSION}-cuda${CUDA_VERSION}-libtorch${TORCH_VERSION}-x86_64-linux.tar.gz
}

build_libtorchtrt_pre_cxx11_abi() {
    bazel build //:libtorchtrt --config pre_cxx11_abi --platforms //toolchains:ci_rhel_x86_64_linux -c opt --noshow_progress
    CUDA_VERSION=$(cd ${PROJECT_DIR}/py/torch_tensorrt && python3 -c "from _version import __cuda_version__;print(__cuda_version__)")
    TORCHTRT_VERSION=$(cd ${PROJECT_DIR}/py/torch_tensorrt && python3 -c "from _version import __version__;print(__version__)")
    TRT_VERSION=$(cd ${PROJECT_DIR}/py/torch_tensorrt && python3 -c "from _version import __tensorrt_version__;print(__tensorrt_version__)")
    CUDNN_VERSION=$(cd ${PROJECT_DIR}/py/torch_tensorrt && python3 -c "from _version import __cudnn_version__;print(__cudnn_version__)")
    TORCH_VERSION=$(/opt/python/cp310-cp310/bin/python -c "from torch import __version__;print(__version__.split('+')[0])")
    cp ${PROJECT_DIR}/bazel-bin/libtorchtrt.tar.gz ${PROJECT_DIR}/py/dist/libtorchtrt-${TORCHTRT_VERSION}-pre-cxx11-abi-cudnn${CUDNN_VERSION}-tensorrt${TRT_VERSION}-cuda${CUDA_VERSION}-libtorch${TORCH_VERSION}-x86_64-linux.tar.gz
}

build_py37
build_py38
build_py39
build_py310
#build_py311
build_libtorchtrt_pre_cxx11_abi
#build_libtorchtrt