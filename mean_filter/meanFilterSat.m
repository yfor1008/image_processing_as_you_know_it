function [filtered] = meanFilterSat(im, halfRadius)
% meanFilterSat - 改进均值滤波, 使用积分图
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
%

im_pad = impadding(im, halfRadius);
im_pad1 = zeros(size(im_pad)+1); % 增加初始行列, 方便计算
im_pad1(2:end, 2:end) = im_pad;

% 积分图, 这里使用 matlab 自带函数实现, matlab 实现耗时少, 稳定, 详细参看:
% https://github.com/yfor1008/image_processing_as_you_know_it/tree/master/integral_image
im_sat = cumsum(im_pad1, 1);
im_sat = cumsum(im_sat, 2);

% 滤波
[H, W] = size(im);
filtered = zeros(H, W);
blockSize = (halfRadius*2+1) * (halfRadius*2+1);
for r = halfRadius+2:halfRadius+H+1
    for c = halfRadius+2:halfRadius+W+1
        blockVal = im_sat(r+halfRadius, c+halfRadius) - im_sat(r-halfRadius-1, c+halfRadius) ...
                 - im_sat(r+halfRadius, c-halfRadius-1) + im_sat(r-halfRadius-1, c-halfRadius-1);
        filtered(r-halfRadius-1, c-halfRadius-1) = blockVal;
    end
end
filtered = round(filtered / blockSize);

end