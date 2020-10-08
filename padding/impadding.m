function [padded] = impadding(im, halfRadius)
%impadding - 对图像边界进行填充, 填充值为最邻近值
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
%

[H, W] = size(im);
padNum = halfRadius * 2;

top = repmat(im(1, :), halfRadius, 1);
down = repmat(im(end, :), halfRadius, 1);
left = repmat(im(:, 1), 1, halfRadius);
right = repmat(im(:, end), 1, halfRadius);
lt = repmat(im(1, 1), halfRadius);
ld = repmat(im(end, 1), halfRadius);
rt = repmat(im(1, end), halfRadius);
rd = repmat(im(end, end), halfRadius);

padded = zeros(H + padNum, W + padNum);
padded(halfRadius+1 : halfRadius+H, halfRadius+1 : halfRadius+W) = im;
padded(1 : halfRadius, halfRadius+1 : halfRadius+W) = top;
padded(halfRadius+H+1 : end, halfRadius+1 : halfRadius+W) = down;
padded(halfRadius+1 : halfRadius+H, 1 : halfRadius) = left;
padded(halfRadius+1 : halfRadius+H, halfRadius+W+1 : end) = right;
padded(1 : halfRadius, 1 : halfRadius) = lt;
padded(halfRadius+H+1 : end, 1 : halfRadius) = ld;
padded(1 : halfRadius, halfRadius+W+1 : end) = rt;
padded(halfRadius+H+1 : end, halfRadius+W+1 : end) = rd;

end