close all; clear; clc;

% read image
im = imread('timg.jpg');
% imshow(im)

im = rgb2gray(im);
[hist] = hist_count(im);
bar(hist)

