#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs

TOOLS=build/tools
DATA=CFW_60k
NUM_LABEL=15 # 1 category label and 14 attributes
DATA_ROOT=/home/liu/JLBC_data_v1.0/cfw_60k/

# Set RESIZE=true to resize the images to 64x64. Leave as false if images have
# already been resized using another tool.
RESIZE=true
if $RESIZE; then
  RESIZE_HEIGHT=100
  RESIZE_WIDTH=100
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

echo "Creating train lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle \
    $DATA_ROOT \
    $DATA/train.txt \
    $DATA/CFW_train_lmdb \
    $NUM_LABEL

echo "Creating val lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $DATA_ROOT \
    $DATA/test.txt \
    $DATA/CFW_test_lmdb \
    $NUM_LABEL

