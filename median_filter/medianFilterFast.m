function [filtered] = medianFilterFast(im, halfRadius)
% medianFilterFast - 快速中值滤波, 参考: "A Fast Two-Dimensional Median Filtering Algorithm"
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
%

filtered = im;
im_pad = impadding(im, halfRadius);
winNum = (halfRadius*2+1) * (halfRadius*2+1);
ratio = winNum * 0.5;

[H, W] = size(im);
rowEnv = mod(H, 2);
hist = hist_count(im_pad(1:halfRadius*2+1, 1:halfRadius*2+1));
for r = halfRadius+1:2:halfRadius+H-rowEnv
    cur_r = r - halfRadius;
    % 当前行第 1 列
    filtered(cur_r,1) = getRatioIndex1(hist, ratio);
    % 减去前一个 block 的第一列, 加上当前 block 的最会一列
    for c = halfRadius+2:halfRadius+W
        cur_c = c-halfRadius;
        hist_left = hist_count(im_pad(cur_r:r+halfRadius, cur_c-1));
        hist_right = hist_count(im_pad(cur_r:r+halfRadius, c+halfRadius));
        hist = hist - hist_left + hist_right;
        filtered(cur_r,cur_c) = getRatioIndex1(hist, ratio);
    end
    % 下一行, 减去当前 block 第一行, 加上下一个 block 的最后一行
    hist_cur = hist_count(im_pad(cur_r, cur_c:c+halfRadius));
    hist_next = hist_count(im_pad(r+1+halfRadius, cur_c:c+halfRadius));
    hist = hist - hist_cur + hist_next;
    filtered(cur_r+1,end) = getRatioIndex1(hist, ratio);
    % 减去后一个 block 的最后一列, 加上当前 block 的第一列
    for c = halfRadius+W-1:-1:halfRadius+1
        cur_c = c-halfRadius;
        hist_right = hist_count(im_pad(r+1-halfRadius:r+1+halfRadius, c+halfRadius+1));
        hist_left = hist_count(im_pad(r+1-halfRadius:r+1+halfRadius, c-halfRadius));
        hist = hist - hist_right + hist_left;
        filtered(cur_r+1,cur_c) = getRatioIndex1(hist, ratio);
    end
    % 更新为下一行第一列
    hist_cur = hist_count(im_pad(r+1-halfRadius, cur_c:c+halfRadius));
    hist_next = hist_count(im_pad(min(r+1+halfRadius+1, size(im_pad, 1)), cur_c:c+halfRadius));
    hist = hist - hist_cur + hist_next;
end

if rowEnv
    % 若图像行为奇数, 则为最后行处理
    filtered(end,1) = getRatioIndex1(hist, ratio);
    % 减去前一个 block 的第一列, 加上当前 block 的最会一列
    for c = halfRadius+2:halfRadius+W
        cur_c = c-halfRadius;
        hist_left = hist_count(im_pad(H:H+halfRadius*2, cur_c-1));
        hist_right = hist_count(im_pad(H:H+halfRadius*2, c+halfRadius));
        hist = hist - hist_left + hist_right;
        filtered(end,cur_c) = getRatioIndex1(hist, ratio);
    end
end

filtered = filtered - 1; % matlab 的 index 从 1 开始, 这里转换成从 0 开始

end

function [hist] = hist_count(im)
hist = zeros(256, 1);
[H, W] = size(im);
for i = 1:H*W
    hist(im(i)+1) = hist(im(i)+1) + 1;
end
end