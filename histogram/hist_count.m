function [h_gray, h_r, h_g, h_b] = hist_count(im)
% hist_count - 获取图像直方图
%
% input:
%   - im: H*W*C, uint8, C=3时为RGB图像, C=1时为gray图像
% output:
%   - h_gray: 256*1, int/float, 灰度直方图
%   - h_r: 256*1, int/float, R通道直方图
%   - h_g: 256*1, int/float, G通道直方图
%   - h_b: 256*1, int/float, B通道直方图
%
% usage:
%   [h_gray, h_r, h_g, h_b] = hist_count(im); % 输出所有直方图, 此时im必须为RGB图像
%   hist = hist_count(im); % 仅输出灰度直方图, 此时im可以为RGB图像或者gray图像
%

[~, ~, C] = size(im);

if nargout == 1

    if C == 3
        im = rgb2gray(im);
    end
    im = im(:);

    h_gray = zeros(256, 1);
    for i = 1:length(im)
        h_gray(im(i)+1) = h_gray(im(i)+1) + 1;
    end

elseif nargout == 4

    if C == 3
        im_r = im(:,:,1);
        im_g = im(:,:,2);
        im_b = im(:,:,3);
        im = rgb2gray(im);
    else
        error('输出参数数目不对, 请查看函数帮助');
    end

    h_gray = zeros(256, 1);
    h_r = zeros(256, 1);
    h_g = zeros(256, 1);
    h_b = zeros(256, 1);
    for i = 1:length(im)
        h_gray(im(i)+1) = h_gray(im(i)+1) + 1;
        h_r(im_r(i)+1) = h_r(im_r(i)+1) + 1;
        h_g(im_g(i)+1) = h_g(im_g(i)+1) + 1;
        h_b(im_b(i)+1) = h_b(im_b(i)+1) + 1;
    end

else
    error('输出参数数目不对, 请查看函数帮助');
end

end