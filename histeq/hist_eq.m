function [T, eq] = hist_eq(hist, show)
% hist_eq - 计算映射函数
%
% input:
%   - hist: n*1, 直方图, n为图像灰度个数
%   - show: bool, 是否显示结果
% output:
%   - T: n*1, 映射函数
%   - eq: n*1, 调整后的直方图
%

grayLevel = length(hist);

if ~exist('show', 'var')
    show = 0;
end

cdf = cumsum(hist);
if cdf(end) > 1
    cdf = cdf / cdf(end);
end

T = fix(cdf * (grayLevel-1)) + 1;

eq = zeros(grayLevel, 1);
for i = 1:grayLevel
    eq(T(i)) = eq(T(i)) + hist(i);
end

if show
    show_process(hist, eq, cdf);
end

end

function show_process(hist, eq, cdf)
% show_process - 显示变换过程
%
% input:
%   - hist: n*1, 直方图, n为图像灰度个数
%   - eq: n*1, 调整后的直方图
%   - cdf: n*1, 累计直方图
%

figure('NumberTitle', 'off', 'Name', 'Porcess of Histogram Equalization')
T = tiledlayout(2,2);

colors = {'r', 'g', 'b', 'c'};

grayVal = 1 : length(hist);

nexttile(1)
barh(grayVal', eq, 'FaceColor', colors{2}, 'BarWidth', 1.0);
set(gca, 'color', 'none'); % set background
set(gca,'XDir','reverse');
ylim([1, length(hist)])

nexttile(2)
plot(grayVal', fix(cdf*(length(hist)-1))+1, 'color', colors{4}, 'linewidth', 1.1);
axis([1, length(hist) 1 length(hist)])
set(gca, 'color', 'none'); % set background

nexttile(4)
bar(grayVal', hist, 'FaceColor', colors{3}, 'BarWidth', 1.0);
set(gca, 'color', 'none'); % set background
hold on,

xlim([1, length(hist)])


T.TileSpacing = 'compact';
T.Padding = 'compact';

end