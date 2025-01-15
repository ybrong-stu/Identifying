function res = demoForAgeEstimation

load('net-face-age-estimation.mat')
im = imread('100_1_0_20170112213303693.jpg.chip.jpg');
gt = 100;
fs = 15;
res = searchFilterForRegression(net,im,fs,gt);
