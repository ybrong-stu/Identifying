function res = demoForImageClassification

load('net-cifar-classification.mat')
load('cifar-test_samples');
fs = 15;
i = 3;  % image index 
gts = labels+1;
im = reshape(data(i,:),[32,32,3]);
gt = gts(i,1);
res = searchFilterForClassification(net,im,fs,gt);
