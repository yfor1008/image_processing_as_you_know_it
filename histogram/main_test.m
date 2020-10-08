close all; clear; clc;

% read image
im = imread('./src/timg.jpg');
% imshow(im)


% hist
% [h_gray] = hist_count(im, 1); % 灰度直方图
[h_gray, h_r, h_g, h_b] = hist_count(im, 0); % RGB 直方图


% ratio index
index = getRatioIndex(h_gray, 1.);


% hist analysis
addpath('../gaussian_fit/');
[outHist] = hist_analysis(h_gray, 1);


% show peaks on image
show_peak(im, outHist);
