close all; clear; clc;

size_low = 480;
size_up = 1024;
imSize = round(size_low + (size_up - size_low) * rand(1));

im = round(rand(imSize, imSize) * 255);
radius_low = 1;
radius_up = 15;
rSize = round(radius_low + (radius_up - radius_low) * rand(1));
imPad = impadding(im, rSize);
figure, imshow(uint8(im))
figure, imshow(uint8(imPad))
