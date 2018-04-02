#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs

TOOLS=build/tools
DATA=ImageNet_150k
NUM_LABEL=26 # 1 category label and 25 attributes

# You need to change the following two lines according to where your data is stored
TRAIN_DATA_ROOT=/home/data/liuhaomiao/ImageNet-150K/train/
TEST_DATA_ROOT=/home/data/liuhaomiao/ImageNet-150K/val/

# Set RESIZE=true to resize the images to 64x64. Leave as false if images have
# already been resized using another tool.
RESIZE=true
if $RESIZE; then
  RESIZE_HEIGHT=256
  RESIZE_WIDTH=256
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

echo "Creating train lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle \
    $TRAIN_DATA_ROOT \
    $DATA/train.txt \
    $DATA/imagenet_train_lmdb \
    $NUM_LABEL

echo "Creating test lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $TEST_DATA_ROOT \
    $DATA/test.txt \
    $DATA/imagenet_test_lmdb \
    $NUM_LABEL

