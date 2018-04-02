#!/usr/bin/env sh

GLOG_logtostderr=1 build/tools/caffe train --solver=CFW_60k/solver.prototxt \
  --weights=CFW_60k/Webface_iter_450000.caffemodel --gpu 0
