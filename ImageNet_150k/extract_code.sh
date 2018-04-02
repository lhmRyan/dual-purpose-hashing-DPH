#!/usr/bin/env sh

rm ImageNet_150k/code.dat
rm ImageNet_150k/attribute.dat
rm ImageNet_150k/label.dat

build/tools/extract_features_binary ImageNet_150k/imagenet_iter_29600.caffemodel ImageNet_150k/feature_extraction.prototxt binary_code,attr_predictor,label ImageNet_150k/code.dat,ImageNet_150k/attribute.dat,ImageNet_150k/label.dat 20 0
