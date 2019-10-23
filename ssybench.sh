rm -rf data/cache/  output/*
nvprof -f --quiet --profile-api-trace none --print-gpu-trace --print-nvlink-topology --csv --log-file fgfa.csv -o fgfa.nvvp \
  python experiments/fgfa_rfcn/fgfa_rfcn_end2end_train_test.py --cfg experiments/fgfa_rfcn/cfgs/resnet_v1_101_flownet_imagenet_vid_rfcn_end2end_ohem.yaml 2> fgfa.err  > fgfa.log
