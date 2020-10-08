close all; clear; clc;
addpath('../padding/');
addpath('../histogram/');

[file, path] = uigetfile('*.bmp; *.png; *.jpg', 'select file ...');
im = imread([path, file]);

gray = rgb2gray(im);
% gray = imresize(gray, [513, 513]);
% imshow(im)

r = 3;

% padded = impadding(gray, r);
filtered = medianFilter(gray, r);
filtered1 = medfilt2(gray, [r*2+1, r*2+1]);
filtered2 = medianFilterFast(gray, r);

% 差别
diff = uint8(abs(double(filtered) - double(filtered2)));
% imshow([filtered, filtered2, diff])
imshow(double(diff(r+1:end-r, r+1:end-r)))
