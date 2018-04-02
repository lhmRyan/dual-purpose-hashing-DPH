#include <algorithm>
#include <cfloat>
#include <vector>

#include "caffe/layer.hpp"
#include "caffe/util/math_functions.hpp"
#include "caffe/layers/weighted_cross_entropy_loss_layer.hpp"

namespace caffe {

template <typename Dtype>
void WeightedCrossEntropyLossLayer<Dtype>::LayerSetUp(
    const vector<Blob<Dtype>*>& bottom, const vector<Blob<Dtype>*>& top) {
  LossLayer<Dtype>::LayerSetUp(bottom, top);
  sigmoid_bottom_vec_.clear();
  sigmoid_bottom_vec_.push_back(bottom[0]);
  sigmoid_top_vec_.clear();
  sigmoid_top_vec_.push_back(sigmoid_output_.get());
  sigmoid_layer_->SetUp(sigmoid_bottom_vec_, sigmoid_top_vec_);
  dim_weight_.clear();
  std::copy(this->layer_param_.sigmoid_loss_param().dim_weight().begin(),
      this->layer_param_.sigmoid_loss_param().dim_weight().end(),
      std::back_inserter(dim_weight_));
}

template <typename Dtype>
void WeightedCrossEntropyLossLayer<Dtype>::Reshape(
    const vector<Blob<Dtype>*>& bottom, const vector<Blob<Dtype>*>& top) {
  LossLayer<Dtype>::Reshape(bottom, top);
  CHECK_EQ(bottom[0]->count(), bottom[1]->count()) <<
      "WEIGHTED_CROSS_ENTROPY_LOSS layer inputs must have the same count.";
  sigmoid_layer_->Reshape(sigmoid_bottom_vec_, sigmoid_top_vec_);
}

template <typename Dtype>
void WeightedCrossEntropyLossLayer<Dtype>::Forward_cpu(
    const vector<Blob<Dtype>*>& bottom, const vector<Blob<Dtype>*>& top) {
  // The forward pass computes the sigmoid outputs.
  sigmoid_bottom_vec_[0] = bottom[0];
  sigmoid_layer_->Forward(sigmoid_bottom_vec_, sigmoid_top_vec_);
  // Compute the loss (negative log likelihood)
  const int count = bottom[0]->count();
  const int num = bottom[0]->num();
  // Stable version of loss computation from input data
  const Dtype* input_data = bottom[0]->cpu_data();
  const Dtype* target = bottom[1]->cpu_data();
  Dtype loss = 0;
  for (int i = 0; i < count; ++i) {
    if (target[i]!=2){
      loss -= input_data[i] * (target[i] - (input_data[i] >= 0)) -
          log(1 + exp(input_data[i] - 2 * input_data[i] * (input_data[i] >= 0)));
    }
  }
  top[0]->mutable_cpu_data()[0] = loss / num;
}

template <typename Dtype>
void WeightedCrossEntropyLossLayer<Dtype>::Backward_cpu(
    const vector<Blob<Dtype>*>& top, const vector<bool>& propagate_down,
    const vector<Blob<Dtype>*>& bottom) {
  if (propagate_down[1]) {
    LOG(FATAL) << this->type()
               << " Layer cannot backpropagate to label inputs.";
  }
  if (propagate_down[0]) {
    // First, compute the diff
    const int count = bottom[0]->count();
    const int num = bottom[0]->num();
    int scale[25] = {0};
    int channels = count/num;
    const Dtype* sigmoid_output_data = sigmoid_output_->cpu_data();
    const Dtype* target = bottom[1]->cpu_data();
    Dtype* bottom_diff = bottom[0]->mutable_cpu_diff();
    caffe_sub(count, sigmoid_output_data, target, bottom_diff);
    //printf("%d\n",channels);
    // Scale down gradient
    for (int i=0; i<count; i++){
      if (target[i]==1){
        bottom_diff[i] *= 2*dim_weight_[i%channels]/(dim_weight_[i%channels]+1);
      }
      else if (target[i]==0){
        bottom_diff[i] *= 2/(dim_weight_[i%channels]+1);
      } 
      else if (target[i]==2){
        bottom_diff[i] = 0;
	scale[i%channels] -= 1;
      }
    }
    for (int i=0; i<channels; i++){
      scale[i] += num;
    }
    const Dtype loss_weight = top[0]->cpu_diff()[0];
    //caffe_scal(count, loss_weight / num, bottom_diff);
    for (int i=0; i<count; i++){
      if (scale[i%channels]!=0){
	bottom_diff[i] *= loss_weight / scale[i%channels];
      }
    }
  }
}

#ifdef CPU_ONLY
STUB_GPU_BACKWARD(WeightedCrossEntropyLossLayer, Backward);
#endif

INSTANTIATE_CLASS(WeightedCrossEntropyLossLayer);
REGISTER_LAYER_CLASS(WeightedCrossEntropyLoss);

}  // namespace caffe
