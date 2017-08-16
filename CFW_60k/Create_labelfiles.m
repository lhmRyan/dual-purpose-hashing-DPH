clear all
clc
%% Load data
fprintf('Loading data.\n')
load('dataset_info.mat');
fprintf('Creating list files.\n')
attribute_train(attribute_train < 0) = 0;
attribute_test(attribute_test < 0) = 0;
%% Training data

f = fopen('train.txt','wt');
for i = 1:length(name_train)
  fprintf(f, '%s ', name_train{i});
  fprintf(f, '%d ', label_train(i));
  for j = 1:size(attribute_train,2)
    fprintf(f, '%d ', attribute_train(i,j));
  end
  fprintf(f, '\n');
end
fclose(f);
%% Test data

f = fopen('test.txt','wt');
for i = 1:length(name_test)
  fprintf(f, '%s ', name_test{i});
  fprintf(f, '%d ', label_test(i));
  for j = 1:size(attribute_test,2)
    fprintf(f, '%d ', attribute_test(i,j));
  end
  fprintf(f, '\n');
end
fclose(f);