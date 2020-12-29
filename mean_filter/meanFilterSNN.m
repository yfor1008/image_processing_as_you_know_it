function [filtered] = meanFilterSNN(im, halfRadius)
% meanFilterSNN - 均值滤波, 使用 SNN(Symmetric Nearest Neighbor)
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
%
% docs:
%   - 参考："Smooth operator: Smoothing seismic interpretations and attributes"
%   - 基本原理为：
%   - 计算中心对称的像素对与中心像素的差别
%   - 取差别较小的像素xi
%   - 所有像素xi的均值为滤波结果
%

filtered = im;
im_pad = impadding(im, halfRadius);
halfWin = 2 * halfRadius * (halfRadius + 1);
NN = zeros(halfWin, 1);

[H, W] = size(im);
for r = halfRadius+1:halfRadius+H
    for c = halfRadius+1:halfRadius+W
        win = im_pad(r-halfRadius:r+halfRadius, c-halfRadius:c+halfRadius);
        % 拉成1列
        win = win';
        win = win(:);
        % 前一半与后一半，一一对应构成像素对
        winT = win(1:halfWin);
        winB = win(halfWin+2:end);
        winB = winB(end:-1:1);
        PP = [winT, winB]; % pixel pair
        % 查找像素对中与中间像素最接近的像素
        [~, idx] = min(abs(PP - win(halfWin+1)), [], 2);
        for i = 1 : halfWin
            NN(i) = PP(i, idx(i));
        end
        % 所有近邻像素均值
        % filtered(r-halfRadius,c-halfRadius) = round(mean([NN; win(halfWin+1)]));
        filtered(r-halfRadius,c-halfRadius) = round(mean(NN));
    end
end

end