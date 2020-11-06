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
labeled11 = label2rgb(labeled1, 'jet', 'k', 'shuffle');
figure, imshow(labeled11)
title('Label Image')

% contourtrace
labeled2 = contourTrace(BW);
labeled22 = label2rgb(labeled2, 'jet', 'k', 'shuffle');
figure, imshow(labeled22)
title('Label Image')
