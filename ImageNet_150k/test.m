codelenth = 256;
num_attr = 25;
N = 2000;
%% Load files
f=fopen('code.dat','rb');
B = zeros(N,codelenth);
for i=1:N
  B(i,:)=fread(f, codelenth, 'float');
end
fclose(f);

f=fopen('label.dat','rb');
label=fread(f,N,'float');
fclose(f);

f=fopen('attribute.dat','rb');
attr_pred = zeros(N, num_attr);
for i=1:N
  attr_pred(i,:)=fread(f, num_attr, 'float');
end
fclose(f);
%% Category retrieval
B = sign(B - 0.5);
[~, ~, map] = compute_map(-B*B', label, label, true);
fprintf('Retrieval mAP of category retrieval: %f\n', map);
%% Attribute retrieval
load('dataset_info.mat','attribute_test');
attribute_test(attribute_test <=0 ) = 0;
map_attribute = compute_map_attribute( attr_pred, attribute_test);
fprintf('Retrieval mAP of attribute retrieval: %f\n', map_attribute);
%% Combined retrieval
load('dataset_info.mat','label_test');
result = compute_recall_combined(B, B, attr_pred, attr_pred, label_test, label_test, attribute_test, attribute_test, 1);
for i=1:size(result, 3)
    temp = result(:,:,i);
    recall(i)=mean(temp(~isnan(temp)));
end
fprintf('Recall of combined retrieval@{5,10,20,50,75,100}: \n');
recall
