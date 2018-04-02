This is the README information of the following publication:
=========================================================================
Learning Multifunctional Binary Codes for Both Category and Attribute Oriented Retrieval Tasks,

Version 1.0,  Copyright(c) July, 2017

Haomiao Liu, Ruiping Wang, Shiguang Shan, Xilin Chen.

All Rights Reserved.

-------------------------------------------------------------------------
 
Example usage:
=========================================================================
1. Modify "Makefile.config" according to your system, and follow the 
   instructions on "http://caffe.berkeleyvision.org/installation.html"
   to compile the source code (only "make all" is needed, you don't need
   to compile the test codes). This version of caffe is tested with 
   cudnn v6.

2. Run "CFW_60k/Create_labelfiles.m" or "ImageNet_150k/Create_labelfiles.m"
   in MATLAB to generate the list files of training and test data. These
   two scripts must be executed in "CFW_60k" or "ImageNet_150k" folder 
   respectively.

3. Run "CFW_60k/create_CFW.sh" or "ImageNet_150k/create_ImageNet.sh" to 
   convert the data to LMDB format. You may need to modify the paths in
   these files according to where you stored your data.

4. Run "CFW_60k/train_net.sh" or "ImageNet_150k/train_net.sh" to train
   an example model with 256-bit binary code. You can modify the 
   "train_test.prototxt" by changing "num_output" of the "binary_code"
   layer to produce models for other codelengths. The pre-trained model
   on CFW-60k could be obtained at "https://pan.baidu.com/s/1kU8nAx5" 
   with password "a9m7" or at 
   "https://drive.google.com/file/d/0B1jyDIC9CcdZeHRSNmwyS08zM2M/view?usp=sharing", 
   and the pre-trained model on ImageNet-150k could be obtained by 
   using the following command:
   "./scripts/download_model_binary.py models/bvlc_reference_caffenet"
   Note that you need to put the pre-trained models in the corresponding
   folders, as in indicated in "train_net.sh".

5. Run "CFW_60k/extract_code.sh" or "ImageNet_150k/extract_code.sh" to 
   get the "real-valued" binary code, category labels, and predicted 
   attributes of test images, stored in "code.dat", "label.dat", and 
   "attribute.dat" respectively. For more details about these files, 
   please refer to "tools/extract_features_binary.cpp" and "test_map.m"
   for more details. You can modify the paths in these files to extract
   binary codes from other models.

6. Run "CFW_60k/test.m" or "ImageNet_150k/test.m" to compute the 
   retrieval mAP or recall of the model on different tasks (this may
   take some time). Note that in the paper, all evaluations on 
   ImageNet-150k, including our method and the comparative methods, are
   performed with data augmentation (four corners and center crop, and 
   their horizontal flips), thus it is normal that the performance on 
   ImageNet-150k is a little bit lower than that reported in the paper.

-------------------------------------------------------------------------

About the datasets:
=========================================================================
1. For CFW-60k, we follow the original publication to partition the dataset,
   resulting in 55,000 training images and 5,000 test images. Among the 
   training images, the first 1,000 correspond to "Train-Both" set, the
   following 4,000 belong to "Train-Attribute" set, and the last 50,000
   are the "Train-Category" set. Please refer to the paper and 
   "CFW_60k/dataset_info.mat" for more details.

2. For ImageNet-150k, we have 148,000 training images and 2,000 test 
   images. Similarly, we have partitioned the data into four sets. Among
   the training set, the first 5,000 correspond to "Train-Both" set, the
   following 43,000 belong to "Train-Attribute" set, and the last 100,000
   are the "Train-Category" set. Please refer to the paper and 
   "ImageNet_150k/dataset_info.mat" for more details.

3. On both datasets, the attributes are annotated with negative (-1), 
   unsure (0), positive (+1), and missing (2). In our experiments, both
   negative samples (-1) and unsure samples (0) are treated as negative.

-------------------------------------------------------------------------

About the cost-sensitive sigmoid cross entropy loss:
=========================================================================
This loss function is used in our method for attribute prediction. For 
the j-th attribute, the weights for positive and negative samples are 
calculated as follows:

r_j = number of negative sample / number of positive sample

w_j^positive = r_j / (r_j + 1)
w_j^negative = 1 / （r_j + 1）

In our implementation, r_j are listed in the prototxt files. For more 
details about this loss function, please refer to the paper (Section 3.3).


-------------------------------------------------------------------------

Demos:
=========================================================================

A video demo of the proposed image retrieval method is available at: 
https://youtu.be/93ZJNGtvlqU or 
http://v.youku.com/v_show/id_XMjkwMzA5MzI3Ng==.html?spm=a2h3j.8428770.3416059.1

A web demo of the proposed method is under development, and will be 
available soon, please stay focused.

-------------------------------------------------------------------------

Please refer to the following paper if you find the source code and the ImageNet-150k dataset helpful:
=========================================================================
Haomiao Liu, Ruiping Wang, Shiguang Shan, Xilin Chen.

Learning Multifunctional Binary Codes for Both Category and Attribute Oriented Retrieval Tasks

In Proc. CVPR 2017.

Contact: haomiao.liu@vipl.ict.ac.cn

========================================================================
