# first time run
# this is for cuda 8
nvidia-docker run -v /home/nfs1/ssy:/home/ssy -w /home/ssy --name ssyFGFA1 -it  ubuntu:16.04 

# second time run
#nvidia-docker start ssyFGFA1
#nvidia-docker exec -it ssyFGFA1 /bin/bash

######################3all in docker ########################
apt update 
apt install -y git vim tmux make module-init-tools build-essential pkg-config libopenblas-dev python-opencv libopencv-dev python-pip ctags


# only for cuda8
# installing cuda, causetion:chose N for installing driver    
sh cuda_8.0.61_375.26_linux.run                              
# add "export PATH=/usr/local/cuda/bin:$PATH" to ~/.bashrc   
# this is the real install of driver                         
sh cuda_8.0.61_375.26_linux.run -silent -driver              
sh cuda_8.0.61.2_linux.run
# install cudnn                                              
tar -zxvf cudnn-8.0-linux-x64-v6.0.tgz                       
cp -r cuda/* /usr/local/cuda-8.0/                  


pip install Cython
pip install opencv-python==3.2.0.6
pip install easydict==1.6
pip install pyyaml
pip install Pillow scipy dill graphviz

# clone mxnet 
git clone --recursive https://github.com/shengyushen/incubator-mxnet
cd incubator-mxnet
# have confirmed that v0.10.0 can not work because of mismatching length of returning infer_shape result
#git checkout v0.10.0
# this version is between 1.0.0 and 1.0.1
git checkout 3df9bf802021d5aa67c609c6736acee94aaf3a48
# this does not seems to work
git submodule update
# so I manually check out all modules in .gitmodules
grep url  .gitmodules |awk '{print "git clone " $NF}' > chkout.sh
source chkout.sh
# copy FGFA operators
cp ../../Flow-Guided-Feature-Aggregation/fgfa_rfcn/operator_cxx/* ./src/operator/contrib/
# copy back my change
cp mxnetpatch/visualization.py ../incubator-mxnet/python/mxnet/visualization.py
cp mxnetpatch/iter_image_recordio_2.cc ../incubator-mxnet/src/io/iter_image_recordio_2.cc
cp mxnetpatch/convolution_v1-inl.h ../incubator-mxnet/src/operator/convolution_v1-inl.h
cp mxnetpatch/deconvolution-inl.h ../incubator-mxnet/src/operator/deconvolution-inl.h
cp mxnetpatch/elemwise_binary_scalar_op_basic.cc ../incubator-mxnet/src/operator/tensor/elemwise_binary_scalar_op_basic.cc

# compile
# you may need to fix some error in compiling this version
# or eles you need to first check out https://github.com/shengyushen/incubator-mxnet
#      git clone https://github.com/shengyushen/incubator-mxnet
# and then apply my patch file to it
# 
make -j4 USE_OPENCV=1 USE_BLAS=openblas USE_CUDA=1 USE_CUDA_PATH=/usr/local/cuda USE_CUDNN=1 ADD_CFLAGS=-I/usr/include/openblas ADD_LDFLAGS=-L/usr/lib64
# install mxnet
cd python
python setup.py install

# run FGFA
# if you see libcudart.so.9.xxx can not found 
# it because the lib dir is built with cuda9,
# just remove all .so files in lib and run sh init.sh again
cd Flow-Guided-Feature-Aggregation/
./plot.sh



