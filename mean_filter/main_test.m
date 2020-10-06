close all; clear; clc;

[file, path] = uigetfile('*.bmp; *.png; *.jpg', 'select file ...');

im = imread([path, file]);
gray = rgb2gray(im);
gray = imresize(gray, [513, 513]);
% imshow(im)

r = 3;

% padded = impadding(gray, r);
filtered = meanFilter(gray, r);
filtered2 = meanFilterModify(gray, r);
filtered3 = meanFilterSat(gray, r);

% matlab 实现, 调用了 intel IPP 库
h = ones(2*r+1, 2*r+1) / ((2*r+1) * (2*r+1));
filtered1 = imfilter(gray, h, 'replicate');

% 差别
diff = uint8(abs(double(filtered) - double(filtered3)));
% imshow([filtered, filtered2, diff])
imshow(double(diff))
