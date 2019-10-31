#!/bin/bash
rm -f result
touch result
#for iter in 3 5 11; do
for iter in 3 5 11; do
  for res in 1 2 3 5; do
    # prepare the config file
    cp experiments/fgfa_rfcn/cfgs/resnet_v1_101_flownet_imagenet_vid_rfcn_end2end_ohem.yaml.temp experiments/fgfa_rfcn/cfgs/resnet_v1_101_flownet_imagenet_vid_rfcn_end2end_ohem.yaml
    sed -i "s/CONV_DEPTH_TEMP/${iter}/g" experiments/fgfa_rfcn/cfgs/resnet_v1_101_flownet_imagenet_vid_rfcn_end2end_ohem.yaml
    sed -i "s/RES_SCALE_TEMP/${res}/g" experiments/fgfa_rfcn/cfgs/resnet_v1_101_flownet_imagenet_vid_rfcn_end2end_ohem.yaml
    # run the computing
		rm -rf data/cache/  output/*
		python experiments/fgfa_rfcn/fgfa_rfcn_end2end_train_test.py --cfg experiments/fgfa_rfcn/cfgs/resnet_v1_101_flownet_imagenet_vid_rfcn_end2end_ohem.yaml 2> fgfa.err  > fgfa.log
    # now the result is in fgfa.log
    mv fgfa.log fgfa.log_${iter}_${res}
    echo  -n $iter " " >> result
    echo  -n $res  " " >> result
    ./calculate.sh fgfa.log_${iter}_${res} >> result 
  done
done
gnuplot -p -e 'set logscale y;plot "result" u ($2*300):($1==3?$3:1/0) w linesp title "depth==3", "" u ($2*300):($1==3?$3:1/0):3 w labels notitle, ""  u ($2*300):($1==5?$3:1/0) w linesp title "depth==5","" u ($2*300):($1==5?$3:1/0):3 w labels notitle, "" u ($2*300):($1==11?$3:1/0) w linesp title "depth==11","" u ($2*300):($1==11?$3:1/0):3 w labels notitle'

