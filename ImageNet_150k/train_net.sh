#!/usr/bin/env sh

GLOG_logtostderr=1 build/tools/caffe train --solver=ImageNet_150k/solver.prototxt --gpu 0 \
  --weights=ImageNet_150k/bvlc_reference_caffenet.caffemodel

