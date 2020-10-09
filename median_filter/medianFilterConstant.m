function [filtered] = medianFilterConstant(im, halfRadius)
%medianFilterConstant - 改进中值滤波, 时间为常数, 参考: "Median Filter in Constant Time"
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
%

filtered = im;
im_pad = impadding(im, halfRadius);
winSize = halfRadius * 2 + 1;
winNum = winSize * winSize;
ratio = winNum * 0.5;

[H, W] = size(im);

% 初始化第一行所有列的直方图
hists = zeros(W, 256);
for c = 1:halfRadius*2+W
    hists(c, :) = hist_count(im_pad(1:winSize, c));
end

% 计算第一行的中值
hist = sum(hists(1:winSize, :), 1);
filtered(1, 1) = getRatioIndex1(hist, ratio);
for c = halfRadius+2:halfRadius+W
    cur_c = c-halfRadius;
    hist = hist - hists(c-halfRadius-1, :) + hists(c+halfRadius, :);
    filtered(1, cur_c) = getRatioIndex1(hist, ratio);
end

% 更新直方图, 计算其他行
for r = halfRadius+2:halfRadius+H
    cur_r = r-halfRadius;
    % 减去前一行, 加上最后一行
    for c = 1:halfRadius*2+W
        hists(c, im_pad(cur_r-1, c)+1) = hists(c, im_pad(cur_r-1, c)+1) - 1;
        hists(c, im_pad(r+halfRadius, c)+1) = hists(c, im_pad(r+halfRadius, c)+1) + 1;
    end
    hist = sum(hists(1:winSize, :), 1);
    filtered(cur_r, 1) = getRatioIndex1(hist, ratio);
    for c = halfRadius+2:halfRadius+W
        cur_c = c-halfRadius;
        hist = hist - hists(c-halfRadius-1, :) + hists(c+halfRadius, :);
        filtered(cur_r, cur_c) = getRatioIndex1(hist, ratio);
    end
end

filtered = filtered - 1; % matlab 的 index 从 1 开始, 这里转换成从 0 开始

end

function [hist] = hist_count(im)
hist = zeros(1, 256);
[H, W] = size(im);
for i = 1:H*W
    hist(im(i)+1) = hist(im(i)+1) + 1;
end
end