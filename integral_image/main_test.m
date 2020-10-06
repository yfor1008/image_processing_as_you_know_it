close all; clear; clc;

size_low = 480;
size_up = 1024;
imSize = round(size_low + (size_up - size_low) * rand(1));

im = round(rand(imSize, imSize) * 255);
% imshow(uint8(im))

sat = integral_image(im);

sat1 = cumsum(im, 1);
sat1 = cumsum(sat1, 2);

diff = abs(sat - sat1);
imshow(diff)
