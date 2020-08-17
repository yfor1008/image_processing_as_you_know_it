close all; clear; clc;

% read image
im = imread('./src/timg.jpg');
% imshow(im)


% hist
[h_gray, h_r, h_g, h_b] = hist_count(im);
% fig = bar(h_r, 'r', 'BarWidth', 1.0);
% set(fig, 'FaceAlpha', 0.5)
% hold on,
% fig = bar(h_g, 'g', 'BarWidth', 1.0);
% set(fig, 'FaceAlpha', 0.5)
% fig = bar(h_b, 'b', 'BarWidth', 1.0);
% set(fig, 'FaceAlpha', 0.5)
% legend({'R', 'G', 'B'})
% set(gca, 'color', 'none'); % set background
% fig_hist = getframe(gcf);
% fig_hist = fig_hist.cdata;
% alpha = ones(size(fig_hist, 1), size(fig_hist, 2));
% fig_gray = rgb2gray(fig_hist);
% alpha(fig_gray==240) = 0; % get alpha
% imwrite(fig_hist, 'hist.png', 'Alpha', alpha)


% hist analysis
addpath('../gaussian_fit/');
[output] = hist_analysis(h_gray, 1);

