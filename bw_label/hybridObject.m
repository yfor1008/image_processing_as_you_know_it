function [labeled] = hybridObject(bw)
% contourTrace - 区域连通, 基于迭代方法
%
% input:
%   - bw: H*W, 二值图像, 1 为前景, 0 为背景
% output:
%   - labeled: H*W, 标注后的图像, 每一个连通区域内的像素值相同
%
% docs:
%   1. 基于迭代方法的原理详见: "Hybrid object labelling in digital images"
%

[H, W] = size(bw);

labeled = zeros(H, W);
label = 0;

for r = 1:H
    for c = 1:W

        if bw(r, c) && (labeled(r, c) == 0)
            label = label + 1;
            labeled = Label(bw, labeled, label, H, W, c, r);
        end

    end
end

end

function [labeled] = Label(bw, labeled, label, imH, imW, x, y)
% Label - 标注函数
%
% input:
%   - bw: 二值图像
%   - labeled: 标注图像
%   - label: 当前轮廓标签
%   - imH: 图像高度
%   - imW: 图像宽度
%   - x: 坐标
%   - y: 坐标
% output:
%   - labeled: 标注后图像
%

m = x;

while (x - 1 > 1) && bw(y, x - 1)
    x = x - 1;
    labeled(y, x) = label;
end

while (m <= imW) && bw(y, m)
    labeled(y, m) = label;
    m = m + 1;
end

% 这里 x-1 和 x<=m 是为了满足 8 邻域条件, 关键!!!
x = max(x - 1, 1);
m = min(m, imW);
while x <= m
    if (y - 1 > 1) && bw(y - 1, x) && (labeled(y - 1, x) == 0)
        labeled = Label(bw, labeled, label, imH, imW, x, y - 1);
    end
    if (y + 1 <= imH) && bw(y + 1, x) && (labeled(y + 1, x) == 0)
        labeled = Label(bw, labeled, label, imH, imW, x, y + 1);
    end
    x = x + 1;
end

end
