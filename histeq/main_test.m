close all; clear; clc;

% must add histogram path
addpath('../histogram/');

% %% gray image test
% % read image
% im = imread('./src/pout.tif');
% % imshow(im)
% 
% % hist equalization
% im_eq = imHistEq(im, 1);

%% color image test
% read image
im = imread('./src/test.png');
% imshow(im)

% hist equalization
im_eq = imHistEq(im, 1);
