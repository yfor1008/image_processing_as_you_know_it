function [filtered] = meanFilter(im, halfRadius)
% meanFilter - 均值滤波
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
%

filtered = im;
im_pad = impadding(im, halfRadius);

[H, W] = size(im);
for r = halfRadius+1:halfRadius+H
    for c = halfRadius+1:halfRadius+W
        block = im_pad(r-halfRadius:r+halfRadius, c-halfRadius:c+halfRadius);
        filtered(r-halfRadius,c-halfRadius) = round(mean2(block));
    end
end

end