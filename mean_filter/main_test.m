close all; clear; clc;

[file, path] = uigetfile('*.bmp; *.png; *.jpg', 'select file ...');

im = imread([path, file]);
gray = rgb2gray(im);
% imshow(im)

% padded = impadding(gray, 3);
filtered = meanFilter(gray, 3);
imshow(uint8(filtered))
