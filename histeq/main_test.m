close all; clear; clc;

% read image
im = imread('./src/pout.tif');
% imshow(im)

% hist
addpath('../histogram/');
[h_gray] = hist_count(im, 0); % 灰度直方图

% histeq
[T, eq] = hist_eq(h_gray, 0);
im_eq = im;
for h = 1:size(im, 1)
    for w = 1:size(im, 2)
        im_eq(h, w) = T(im(h, w)+1);
    end
end

figure,
imshow([im, im_eq])
