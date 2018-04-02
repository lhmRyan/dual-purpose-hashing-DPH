#!/usr/bin/env sh

rm CFW_60k/code.dat
rm CFW_60k/attribute.dat
rm CFW_60k/label.dat

build/tools/extract_features_binary CFW_60k/CFW_iter_27500.caffemodel CFW_60k/feature_extraction.prototxt binary_code,attr_predictor,label CFW_60k/code.dat,CFW_60k/attribute.dat,CFW_60k/label.dat 50 0

