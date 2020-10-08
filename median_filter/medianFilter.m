function [filtered] = medianFilter(im, halfRadius)
% medianFilter - 中值滤波
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
%

filtered = im;
im_pad = impadding(im, halfRadius);
med_index = round((halfRadius*2+1) * (halfRadius*2+1) / 2);

[H, W] = size(im);
for r = halfRadius+1:halfRadius+H
    for c = halfRadius+1:halfRadius+W
        block = im_pad(r-halfRadius:r+halfRadius, c-halfRadius:c+halfRadius);
        block = block(:);
        block = sort(block);
        filtered(r-halfRadius,c-halfRadius) = block(med_index);
    end
end

end