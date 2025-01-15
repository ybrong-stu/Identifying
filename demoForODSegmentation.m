function res = demoForODSegmentation

load('net-OD-segmentation.mat')
fs = 15;
im = imread('im_20051201_38466_0400_PP.tif');
gt = imread('gt_20051201_38466_0400_PP.tif');
res = searchFilterForSegmentation(net,im,fs,gt);