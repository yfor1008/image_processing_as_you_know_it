close all; clear; clc;


I = imread('rice.png');
I = imresize(I, 3);
% figure, imshow(I)
% title('Synthetic Image')

BW = I > 128;
figure, imshow(BW)
title('Binary Image')

% matlab test
labeled = bwlabel(BW);
labeled = label2rgb(labeled, 'jet', 'k', 'shuffle');
figure, imshow(labeled)
title('Label Image')

% seedfill
labeled1 = seedFill(BW);
labeled1 = label2rgb(labeled1, 'jet', 'k', 'shuffle');
figure, imshow(labeled)
title('Label Image')
