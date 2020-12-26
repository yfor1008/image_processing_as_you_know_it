function [filtered] = meanFilterKuwaharaSat(im, halfRadius)
% meanFilterKuwaharaSat - 使用积分图对 kuwahara 进行改进
%
% input:
%   - im: H*W, gray 图像
%   - halfRadius: int, 滤波窗口半径
% output:
%   - filtered: H*W, 滤波后图像
%
% docs:
%   - 方差公式为: sum(xi^2)/n - u^2, xi为邻域内像素, n 为邻域内像素个数, u 为领域内像素均值
%   - 因而方差可以一阶积分图和二阶积分图表示
%

im_pad = impadding(im, halfRadius);
im_pad1 = zeros(size(im_pad)+1); % 增加初始行列, 方便计算
im_pad1(2:end, 2:end) = im_pad;
im_pad2 = im_pad1 .^ 2;

im_sat1 = cumsum(im_pad1, 1);
im_sat1 = cumsum(im_sat1, 2);
im_sat2 = cumsum(im_pad2, 1);
im_sat2 = cumsum(im_sat2, 2);

% 滤波
[H, W] = size(im);
filtered = zeros(H, W);
blockSize = (halfRadius+1) * (halfRadius+1);
for r = halfRadius+2:halfRadius+H+1
    for c = halfRadius+2:halfRadius+W+1
        % 左上
        lt_std = (im_sat2(r,c) - im_sat2(r-halfRadius-1,c) - im_sat2(r,c-halfRadius-1) + im_sat2(r-halfRadius-1,c-halfRadius-1)) / blockSize;
        lt_mean = (im_sat1(r,c) - im_sat1(r-halfRadius-1,c) - im_sat1(r,c-halfRadius-1) + im_sat1(r-halfRadius-1,c-halfRadius-1)) / blockSize;
        lt_std = lt_std - lt_mean .^ 2;
        % 右上
        rt_std = (im_sat2(r,c+halfRadius) - im_sat2(r-halfRadius-1,c+halfRadius) - im_sat2(r,c-1) + im_sat2(r-halfRadius-1,c-1)) / blockSize;
        rt_mean = (im_sat1(r,c+halfRadius) - im_sat1(r-halfRadius-1,c+halfRadius) - im_sat1(r,c-1) + im_sat1(r-halfRadius-1,c-1)) / blockSize;
        rt_std = rt_std - rt_mean .^ 2;
        % 左下
        ld_std = (im_sat2(r+halfRadius,c) - im_sat2(r-1,c) - im_sat2(r+halfRadius,c-halfRadius-1) + im_sat2(r-1,c-halfRadius-1)) / blockSize;
        ld_mean = (im_sat1(r+halfRadius,c) - im_sat1(r-1,c) - im_sat1(r+halfRadius,c-halfRadius-1) + im_sat1(r-1,c-halfRadius-1)) / blockSize;
        ld_std = ld_std - ld_mean .^ 2;
        % 右下
        rd_std = (im_sat2(r+halfRadius,c+halfRadius) - im_sat2(r-1,c+halfRadius) - im_sat2(r+halfRadius,c-1) + im_sat2(r-1,c-1)) / blockSize;
        rd_mean = (im_sat1(r+halfRadius,c+halfRadius) - im_sat1(r-1,c+halfRadius) - im_sat1(r+halfRadius,c-1) + im_sat1(r-1,c-1)) / blockSize;
        rd_std = rd_std - rd_mean .^ 2;
        % std and mean
        stds = [lt_std, rt_std, ld_std, rd_std];
        means = [lt_mean, rt_mean, ld_mean, rd_mean];
        [~, idx] = min(stds);
        filtered(r-halfRadius-1, c-halfRadius-1) = round(means(idx));
    end
end

end