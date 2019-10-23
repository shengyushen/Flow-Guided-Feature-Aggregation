1 first create docker contaner
     nvidia-docker run -v /home/nfs1/ssy:/home/ssy -w /home/ssy --name ssyFGFA -it  nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
2 run that docker 
     nvidia-docker start ssyFGFA
     nvidia-docker exec -it ssyFGFA /bin/bash
3 following all in the docker  
     install all required package
     apt update
     apt install vim git tmux unzip pkg-config libopencv-dev libopenblas-dev  -y
4 installing mxnet, there are two ways
4.1  goto https://github.com/apache/incubator-mxnet/tags?after=1.1.0  to get v0.10.0 versiton of mxnet
  and untar it
  and then download all submodules in .gitmodule
4.2 or if you have a fully prepared packet, just untar it into incubator-mxnet-0.10.0/
5 copy all fgfa operators to mxnet
     cd incubator-mxnet-0.10.0/
     cp ../Flow-Guided-Feature-Aggregation/fgfa_rfcn/operator_cxx/* ./src/operator/contrib/
6 compile mxnet
     make -j4 USE_OPENCV=1 USE_BLAS=openblas USE_CUDA=1 USE_CUDA_PATH=/usr/local/cuda USE_CUDNN=1
7 install all python binding


