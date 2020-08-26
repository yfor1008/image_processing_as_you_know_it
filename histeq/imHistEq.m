function [im_eq] = imHistEq(im, show)
% imHistEq - 直方图均衡
%
% input:
%   - im: H*W*C, C=3 时为 RGB 图像, C=1 时为灰度图像
%   - show: bool, 是否显示结果
% output:
%   - im_eq: H*W*C, 直方图均衡后的图像
%

if ~exist('show', 'var')
    show = 0;
end

[H,W,C] = size(im);

if C == 3
    hsv = rgb2hsv(im);
    V = hsv(:,:,3);
    V = round(V * 255);
    [h_gray] = hist_count(V);
    [T, ~] = calc_T(h_gray, show);
    V1 = V;
    for h = 1:H
        for w = 1:W
            V1(h, w) = T(V(h, w)+1);
        end
    end
    V1 = V1/255;
    hsv(:,:,3) = V1;
    im_eq = hsv2rgb(hsv);
    im_eq = uint8(round(im_eq*255));
elseif C == 1
    [h_gray] = hist_count(im);
    [T, ~] = calc_T(h_gray, show);
    im_eq = im;
    for h = 1:H
        for w = 1:W
            im_eq(h, w) = T(im(h, w)+1);
        end
    end
else
    error('输入图像通道数必须为 1 或 3');
end

if show
    figure('NumberTitle', 'off', 'Name', 'Result of Histogram Equalization')
    T = tiledlayout(1,2);
    nexttile(1)
    imshow(im)
    title('原始图像')
    nexttile(2)
    imshow(im_eq)
    title('均衡后图像')

    T.TileSpacing = 'compact';
    T.Padding = 'compact';

    set(gca, 'color', 'none');
    fig_rgb = getframe(gcf);
    fig_rgb = fig_rgb.cdata;
    alpha = ones(size(fig_rgb, 1), size(fig_rgb, 2));
    fig_gray = rgb2gray(fig_rgb);
    alpha(fig_gray==240) = 0;
    imwrite(fig_rgb, 'result_of_histeq.png', 'Alpha', alpha);

end

end