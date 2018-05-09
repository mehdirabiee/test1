FROM ubuntu:16.04
LABEL maintainer caffe-maint@googlegroups.com

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
		python-pip \
        python-setuptools \
        python-scipy && \
    rm -rf /var/lib/apt/lists/*

ENV CAFFE_ROOT=/opt/caffe
WORKDIR /opt


RUN mkdir caffe && \
	git clone https://github.com/BVLC/caffe temp1 && \
    git clone https://github.com/hujie-frank/SENet temp2 && \
	git clone https://github.com/mehdirabiee/test1 temp3 && \
	mv temp1/* caffe/ && \
	cp -r temp2/* caffe/ && \
	cp -r temp3/* caffe/ && \
	rm -rf temp1 && \
	rm -rf temp2 && \
	rm -rf temp3 && \
    pip install --upgrade pip && \
    cd caffe/python && \
	pip install -r requirements.txt && \
	cd .. && \
    mkdir build && cd build && \
    cmake -DCPU_ONLY=1 .. && \
    make -j"$(nproc)"

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

WORKDIR /workspace