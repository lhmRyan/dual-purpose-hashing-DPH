This is the README information of the following publication:
=========================================================================
Learning Multifunctional Binary Codes for Both Category and Attribute Oriented Retrieval Tasks,

Version 1.0,  Copyright(c) July, 2017. In Proc. CVPR 2017.

Haomiao Liu, Ruiping Wang, Shiguang Shan, Xilin Chen.

All Rights Reserved.

Contact: haomiao.liu@vipl.ict.ac.cn

-------------------------------------------------------------------------

Source Codes:
=========================================================================

For patent issues, the source codes of this work are released upon request
for research purposes only. Please contact us for details.

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

Demos:
=========================================================================

A video demo of the proposed image retrieval method is available at: 
https://youtu.be/93ZJNGtvlqU or 
http://v.youku.com/v_show/id_XMjkwMzA5MzI3Ng==.html?spm=a2h3j.8428770.3416059.1

A web demo of the proposed method is under development, and will be 
available soon, please stay focused.

-------------------------------------------------------------------------