function [filtered] = meanFilterKuwahara(im, halfRadius)
% meanFilterKuwahara - kuwahara 均值滤波
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
%
% docs:
%   - kuwahara 将像素点所在的区域划分为 4 个子区域
%   - 计算 4 个子区域的方差和均值
%   - 滤波结果取方差最小的区域的均值
%

filtered = im;
im_pad = impadding(im, halfRadius);

[H, W] = size(im);
for r = halfRadius+1:halfRadius+H
    for c = halfRadius+1:halfRadius+W
        % 左上
        lt = im_pad(r-halfRadius:r, c-halfRadius:c);
        % 右上
        rt = im_pad(r-halfRadius:r, c:c+halfRadius);
        % 左下
        ld = im_pad(r:r+halfRadius, c-halfRadius:c);
        % 右下
        rd = im_pad(r:r+halfRadius, c:c+halfRadius);
        % std and mean
        stds = [std(lt(:)), std(rt(:)), std(ld(:)), std(rd(:))];
        means = [mean(lt(:)), mean(rt(:)), mean(ld(:)), mean(rd(:))];
        [~, idx] = min(stds);
        filtered(r-halfRadius,c-halfRadius) = round(means(idx));
    end
end

end